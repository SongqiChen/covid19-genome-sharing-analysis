-- step1. GISAID database: Count of sequences submitted by each province in China in 2023 based on the sequence submission date
-- Requirements: Complete sampling dates, sampling date less than or equal to submission date.
SELECT Province, COUNT(*) AS RecordCount
FROM metadata_gisaid
WHERE Country = 'China'
AND YEAR(STR_TO_DATE(`Submission Date`, '%Y-%m-%D')) = 2023
AND DateDiff IS NOT NULL
AND DateDiff >= 0
GROUP BY Province;

-- step2. GISAID database: Host distribution of sequences submitted by China in 2023 based on the sequence submission date
-- Requirements: Complete sampling dates, sampling date less than or equal to submission date.
SELECT Host, COUNT(*)
FROM metadata_gisaid
WHERE Country = 'China'
AND YEAR(STR_TO_DATE(`Submission Date`, '%Y-%m-%D')) = 2023
AND DateDiff IS NOT NULL
AND DateDiff >= 0
GROUP BY Host;

-- step3. GISAID database: Distribution of sampling dates for sequences submitted by China in 2023 based on the sequence submission date
-- Requirements: Complete sampling dates, sampling date less than or equal to submission date. Host must be human.
SELECT DATE_FORMAT(STR_TO_DATE(`Collection Date`, '%Y-%m-%D'), '%Y-%m') AS CollYearMonth, COUNT(*)
FROM metadata_gisaid
WHERE Country = 'China'
AND YEAR(STR_TO_DATE(`Submission Date`, '%Y-%m-%D')) = 2023
AND DateDiff IS NOT NULL
AND DateDiff >= 0
AND Host = 'Human'
GROUP BY CollYearMonth
ORDER BY CollYearMonth;

-- step4. Count of sequences submitted by China in 2023 that were sampled in the same year, grouped by age and gender
-- Requirements: Complete sampling dates, sampling date less than or equal to submission date. Host must be human.
SELECT AgeRange,
       SUM(CASE WHEN Gender = 'Male' THEN 1 ELSE 0 END) AS Male,
       SUM(CASE WHEN Gender = 'Female' THEN 1 ELSE 0 END) AS Female
FROM (
    SELECT CASE
               WHEN FLOOR(CAST(`Patient age` AS UNSIGNED) / 5) = 0 THEN '0-4'
               WHEN FLOOR(CAST(`Patient age` AS UNSIGNED) / 5) = 1 THEN '5-9'
               WHEN FLOOR(CAST(`Patient age` AS UNSIGNED) / 5) = 2 THEN '10-14'
               WHEN FLOOR(CAST(`Patient age` AS UNSIGNED) / 5) = 3 THEN '15-19'
               WHEN FLOOR(CAST(`Patient age` AS UNSIGNED) / 5) = 4 THEN '20-24'
               WHEN FLOOR(CAST(`Patient age` AS UNSIGNED) / 5) = 5 THEN '25-29'
               WHEN FLOOR(CAST(`Patient age` AS UNSIGNED) / 5) = 6 THEN '30-34'
               WHEN FLOOR(CAST(`Patient age` AS UNSIGNED) / 5) = 7 THEN '35-39'
               WHEN FLOOR(CAST(`Patient age` AS UNSIGNED) / 5) = 8 THEN '40-44'
               WHEN FLOOR(CAST(`Patient age` AS UNSIGNED) / 5) = 9 THEN '45-49'
               WHEN FLOOR(CAST(`Patient age` AS UNSIGNED) / 5) = 10 THEN '50-54'
               WHEN FLOOR(CAST(`Patient age` AS UNSIGNED) / 5) = 11 THEN '55-59'
               WHEN FLOOR(CAST(`Patient age` AS UNSIGNED) / 5) = 12 THEN '60-64'
               WHEN FLOOR(CAST(`Patient age` AS UNSIGNED) / 5) = 13 THEN '65-69'
               WHEN FLOOR(CAST(`Patient age` AS UNSIGNED) / 5) = 14 THEN '70-74'
               WHEN FLOOR(CAST(`Patient age` AS UNSIGNED) / 5) = 15 THEN '75-79'
               WHEN FLOOR(CAST(`Patient age` AS UNSIGNED) / 5) = 16 THEN '80-84'
               WHEN FLOOR(CAST(`Patient age` AS UNSIGNED) / 5) = 17 THEN '85-89'
               WHEN FLOOR(CAST(`Patient age` AS UNSIGNED) / 5) = 18 THEN '90-94'
               WHEN FLOOR(CAST(`Patient age` AS UNSIGNED) / 5) >= 19 THEN '95+'
               ELSE 'Unknown'
           END AS AgeRange,
           Gender
    FROM metadata_gisaid
    WHERE Country = 'China'
      AND DateDiff IS NOT NULL
      AND DateDiff >= 0
      AND Host = 'Human'
      AND YEAR(STR_TO_DATE(`Collection Date`, '%Y-%m-%d')) = 2023
      AND YEAR(STR_TO_DATE(`Submission Date`, '%Y-%m-%d')) = 2023
      AND is_valid_age = TRUE
      AND is_valid_gender = TRUE
) AS AgeGenderGroup
GROUP BY AgeRange
ORDER BY AgeRange;