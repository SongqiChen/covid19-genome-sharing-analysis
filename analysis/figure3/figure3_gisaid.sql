-- Based on the sequence submission date, calculate the proportion of high-quality sequences reported by each country from 2020 to 2023
-- GISAID database: Proportion of high-quality sequences (length above 29000nt and Ns ≤5%) for each country in 2020, 2021, 2022, 2023 by submission year
-- Requirements: Complete sampling dates, sampling date less than or equal to submission date. Countries are determined based on the "Location" field
SELECT
    Year,
    Country,
    SUM(CompleteAndLowCoverageExcludeCountNum) AS CompleteAndLowCoverageExcludeCountNum,
    SUM(AllCountNum) AS AllCountNum,
    FORMAT((SUM(CompleteAndLowCoverageExcludeCountNum) / SUM(AllCountNum) * 100), 2) AS Percent
FROM
    (
        SELECT
            DATE_FORMAT(STR_TO_DATE(`Submission Date`, '%Y-%m-%d'), '%Y') AS Year,
            Country,
            COUNT(*) AS CompleteAndLowCoverageExcludeCountNum,
            0 AS AllCountNum
        FROM metadata_gisaid
        WHERE DateDiff IS NOT NULL
            AND DateDiff >= 0
            AND STR_TO_DATE(`Submission Date`, '%Y-%m-%d') >= '2020-01-01'
            AND STR_TO_DATE(`Submission Date`, '%Y-%m-%d') <= '2023-12-31'
            AND `Sequence length` > 29000
            AND (
                `N-Content` IS NULL OR `N-Content` <= 0.05
            )
        GROUP BY Year, Country
        UNION ALL
        SELECT
            DATE_FORMAT(STR_TO_DATE(`Submission Date`, '%Y-%m-%d'), '%Y') AS Year,
            Country,
            0 AS CompleteAndLowCoverageExcludeCountNum,
            COUNT(*) AS AllCountNum
        FROM metadata_gisaid
        WHERE DateDiff IS NOT NULL
            AND DateDiff >= 0
            AND STR_TO_DATE(`Submission Date`, '%Y-%m-%d') >= '2020-01-01'
            AND STR_TO_DATE(`Submission Date`, '%Y-%m-%d') <= '2023-12-31'
        GROUP BY Year, Country
    ) AS combined
GROUP BY Year, Country
ORDER BY Year, Country;