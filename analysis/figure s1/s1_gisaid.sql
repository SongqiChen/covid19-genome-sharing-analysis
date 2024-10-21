-- step1. Count the number of each Variant in sequences submitted annually
-- Requirements: Submission date between 2020 and 2023, complete sampling and submission dates, and submission date not earlier than sampling date
SELECT
    YEAR(STR_TO_DATE(`Submission Date`, '%Y-%m-%d')) AS Year,
    Variant,
    COUNT(*) AS Count
FROM metadata_gisaid
WHERE DateDiff IS NOT NULL
  AND DateDiff >= 0
  AND YEAR(STR_TO_DATE(`Submission Date`, '%Y-%m-%d')) BETWEEN 2020 AND 2023
GROUP BY Year, Variant
ORDER BY Year, Variant;

-- step2. Count the number of each Variant in sequences submitted annually from China
-- Requirements: Submission date between 2020 and 2023, complete sampling and submission dates, and submission date not earlier than sampling date
SELECT
    YEAR(STR_TO_DATE(`Submission Date`, '%Y-%m-%d')) AS Year,
    Variant,
    COUNT(*) AS Count
FROM metadata_gisaid
WHERE DateDiff IS NOT NULL
  AND DateDiff >= 0
  AND Country = 'China'
  AND YEAR(STR_TO_DATE(`Submission Date`, '%Y-%m-%d')) BETWEEN 2020 AND 2023
GROUP BY Year, Variant
ORDER BY Year, Variant;
