-- step1. Re-import data that failed due to excessively long fields during batch import using SQL
INSERT INTO metadata_gisaid (`Virus name`, `Last vaccinated`, `Passage details/history`, `Type`, `Accession ID`,
                             `Collection date`, `Location`,
                             `Additional location information`, `Sequence length`, `Host`, `Patient age`, `Gender`,
                             `Clade`, `Pango lineage`,
                             `Pango version`, `Variant`, `AA Substitutions`, `Submission date`, `Is reference?`,
                             `Is complete?`,
                             `Is high coverage?`, `Is low coverage?`, `N-Content`, `GC-Content`)
VALUES ('hCoV-19/India/AS-94190/2020', NULL, 'Original', 'betacoronavirus', 'EPI_ISL_11468762', '2020-08-28',
        'Asia / India / Assam / Barpeta',
        NULL, '24921', 'Human', '46', 'Male', 'G', 'B.1.36', 'consensus call', NULL, 'TooLong', '2022-03-28', NULL,
        NULL, 'True', NULL, NULL, '0.378235223306'),
       ('hCoV-19/India/AS-28921/2020', NULL, 'Original', 'betacoronavirus', 'EPI_ISL_11468761', '2020-05-31',
        'Asia / India / Assam / Goalpara / Holdbari Bagan',
        NULL, '24917', 'Human', '20', 'Male', 'O', 'B.6', 'consensus call', NULL, 'TooLong', '2022-03-28', NULL, NULL,
        'True', NULL, NULL, '0.378496608741');

-- step2. Add a Continent field
-- If you encounter the error [HY000][1206] The total number of locks exceeds the lock table size
-- Use the following command to adjust the buffer size SET GLOBAL innodb_buffer_pool_size = 1 * 1024 * 1024 * 1024; -- Set to 1GB
-- Use this command to adjust the redo log buffer size SET GLOBAL innodb_redo_log_capacity = 512 * 1024 * 1024; -- Set to 512MB
-- These adjustments will be reverted upon restart, but they are highly recommended to improve SQL execution speed.
-- Due to the large volume of table data and the text format that makes indexing difficult, the following preprocessing instructions may take a long time to execute
ALTER TABLE metadata_gisaid
ADD COLUMN Continent VARCHAR(64) AFTER Location;
SET SQL_SAFE_UPDATES = 0; # Temporarily disable safe updates due to MySQL strict checking
UPDATE `metadata_gisaid` SET `Continent` = SUBSTRING_INDEX(`Location`, ' / ', 1) WHERE TRUE;
SET SQL_SAFE_UPDATES = 1;

-- step3. Add a Country field
ALTER TABLE metadata_gisaid
ADD COLUMN Country VARCHAR(64) AFTER Continent;
SET SQL_SAFE_UPDATES = 0;
UPDATE `metadata_gisaid` SET `Country` = SUBSTRING_INDEX(SUBSTRING_INDEX(`Location`, ' /', 2), '/ ', -1) WHERE TRUE;
UPDATE `metadata_gisaid`
SET `Country` = CASE
    WHEN `Country` = 'North America/USA/Idaho' THEN 'United States of America'
    ELSE `Country`
END;
SET SQL_SAFE_UPDATES = 1;

-- step4. Add a Province field
ALTER TABLE metadata_gisaid
ADD COLUMN Province VARCHAR(64) AFTER Country;
SET SQL_SAFE_UPDATES = 0;
UPDATE `metadata_gisaid` SET `Province` = SUBSTRING_INDEX(SUBSTRING_INDEX(`Location`, ' /', 3), '/ ', -1) WHERE TRUE;
SET SQL_SAFE_UPDATES = 0;
UPDATE metadata_gisaid
SET Province = CASE
    WHEN Province = 'Weifang' THEN 'Shandong'
    WHEN Province = 'Jining' THEN 'Shandong'
    WHEN Province = 'Meizhou' THEN 'Guangdong'
    WHEN Province = 'Shenzhen' THEN 'Guangdong'
    WHEN Province = 'Wuhan' THEN 'Hubei'
    WHEN Province = 'Changde' THEN 'Hunan'
    WHEN Province = 'Hangzhou' THEN 'Zhejiang'
    WHEN Province = 'Harbin' THEN 'Heilongjiang'
    WHEN Province = 'Lu\'an' THEN 'Anhui'
    WHEN Province = 'NanChang' THEN 'Jiangxi'
    WHEN Province = 'China' THEN 'Unknown'
    WHEN Province = 'South China' THEN 'Unknown'
    ELSE Province
END;
SET SQL_SAFE_UPDATES = 1;

-- step5. Add a DateDiff field to calculate the difference between the collection and submission dates
ALTER TABLE metadata_gisaid
ADD COLUMN DateDiff VARCHAR(64) AFTER `Submission Date`;
SET SQL_SAFE_UPDATES = 0;
UPDATE `metadata_gisaid` SET `DateDiff` =
DATEDIFF(STR_TO_DATE( `Submission Date`, '%Y-%m-%d' ),STR_TO_DATE( `Collection Date`, '%Y-%m-%d' ))
WHERE LENGTH(`Submission Date`)>=8 AND LENGTH(`Collection Date`)>=8;
SET SQL_SAFE_UPDATES = 1;

-- step6. Add an is_valid_gender field to check if the gender is valid
ALTER TABLE metadata_gisaid
ADD COLUMN is_valid_gender BOOLEAN AFTER Gender;
UPDATE metadata_gisaid
SET is_valid_gender = CASE
    WHEN Gender IN ('Male', 'Female') THEN 1
    ELSE 0
END;

-- step7. Add an is_valid_age field to check if the age is valid
ALTER TABLE metadata_gisaid
ADD COLUMN is_valid_age BOOLEAN AFTER `Patient age`;
-- Age is valid if it is an integer or a valid decimal, between 0 and 200, and does not contain '-', '/' or spaces
UPDATE metadata_gisaid
SET is_valid_age = CASE
    WHEN `Patient age` REGEXP '^[0-9]+(\.[0-9]+)?$'
         AND `Patient age` NOT REGEXP '[-/, ]'
         AND CAST(`Patient age` AS DECIMAL) BETWEEN 0 AND 200 THEN 1
    ELSE 0
END;

-- step8. Add indexes to the newly added fields to improve query performance
ALTER TABLE metadata_gisaid
ADD INDEX idx_continent (Continent),
ADD INDEX idx_country (Country),
ADD INDEX idx_province (Province),
ADD INDEX idx_datediff (DateDiff),
ADD INDEX idx_is_valid_gender (is_valid_gender),
ADD INDEX idx_is_valid_age (is_valid_age);