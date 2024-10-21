-- step1. Replace 2020 with the corresponding year, execute this part of SQL, and save the result as a new data table datadiff_years
-- The subsequent step2-step4 calculations will be based on this newly created database table
SELECT Country, DateDiff, COUNT(*) AS RecordCount
FROM metadata_gisaid
WHERE YEAR(STR_TO_DATE(`Submission Date`, '%Y-%m-%d')) = 2020
GROUP BY Country, DateDiff
ORDER BY Country, DateDiff;

-- step2. Fill in records with incomplete sampling dates that cannot be calculated, marking them as -1
SET SQL_SAFE_UPDATES = 0;
UPDATE datediff_2020
SET DateDiff = '-1'
WHERE DateDiff IS NULL;
SET SQL_SAFE_UPDATES = 1;

-- step3. Generate SQL instructions using concatenation and processing, execute, and convert records into a two-dimensional table
-- After running, export the result as a CSV file and save it
SET @EE = '';
SELECT @EE := CONCAT(@EE, 'sum(if(DateDiff= '', DateDiff, '',RecordCount,0)) as '', DateDiff, '',') AS aa
FROM (SELECT DISTINCT DateDiff FROM datediff_2020 ORDER BY DateDiff ASC) A;
SET @QQ = CONCAT('select ifnull(Country,'TOTAL')as Country,', @EE,' sum(RecordCount) as TOTAL from datediff_2020 group by Country WITH ROLLUP');

PREPARE stmt FROM @QQ;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- step4. Run the cal_figure1.py script to calculate the final average, median, etc.
-- The content of the exported CSV file should be similar to below, note that the first row is the header
# Country,-1,0,1,10,100,101,102,103,104,105,106,107,108,109,11,110,111,TOTAL
# Algeria,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3
# Andorra,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
# Argentina,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,50
# Armenia,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3
# Aruba,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,11
# Australia,26,0,3,42,75,88,79,50,100,121,111,121,106,89,78,82,80,16584
# Austria,0,0,0,1,2,10,0,1,1,2,5,5,3,1,1,4,4,762
# Bahrain,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,2,155
# Bangladesh,0,0,0,26,1,0,1,0,1,5,1,0,0,0,25,2,0,608
# Belarus,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10
# Belgium,0,0,0,39,21,6,5,4,6,1,6,2,0,1,49,2,0,2938

-- step5. Extract the mapping relationship between countries and corresponding continents and export it for subsequent statistics and plotting
SELECT Continent, Country
FROM metadata_gisaid
GROUP BY Continent, Country
ORDER BY Continent, Country;