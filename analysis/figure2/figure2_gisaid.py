# coding=utf-8
import pandas as pd
from sqlalchemy import create_engine
from datetime import datetime, timedelta

# For sequences reported by China from 2020 to 2023, with complete sampling dates and submission dates on or after the sampling date. Calculate the median difference and total sequence count grouped by month.

# Set up the database connection
username = 'root'
password = 'password'
database_name = 'gisaid'
host = 'localhost'
port = '3306'
connection_string = f'mysql+pymysql://{username}:{password}@{host}:{port}/{database_name}'
engine = create_engine(connection_string)

# Execute SQL query to get submission dates, country, and the difference between submission and sampling dates for all sequences reported monthly
def query_data(year_month):
    query = f"""
    SELECT
        STR_TO_DATE(`Submission Date`, '%%Y-%%m-%%d') AS `Submission Date`,
        Country,
        DateDiff,
        DATE_FORMAT(STR_TO_DATE(`Submission Date`, '%%Y-%%m-%%D'), '%%Y%%m') AS YearMonth
    FROM
        metadata_gisaid
    WHERE
        Country = 'China'
        AND DateDiff IS NOT NULL
        AND DateDiff >= 0
        AND DATE_FORMAT(STR_TO_DATE(`Submission Date`, '%%Y-%%m-%%D'), '%%Y%%m') = '{year_month}'
    """
    df = pd.read_sql(query, engine)
    df['DateDiff'] = pd.to_numeric(df['DateDiff'], errors='coerce')  # Convert to numeric type, set to NaN if conversion fails
    return df
    # return pd.read_sql(query, engine)

# Iterate over the dates and calculate the median, then save to CSV
start_date = datetime.strptime("202001", "%Y%m")
end_date = datetime.strptime("202312", "%Y%m")
current_date = start_date

results = []  # List to store results
print('current_date','YearMonth', 'Country', 'DateDiff', 'Count')

while current_date <= end_date:
    year_month = current_date.strftime("%Y%m")
    df = query_data(year_month)

    if not df.empty:
        median_date_diff = df['DateDiff'].median()
        count = len(df)
    else:
        median_date_diff = None
        count = 0

    results.append([year_month, 'China', median_date_diff, count])
    print(current_date, year_month, 'China', median_date_diff, count)
    current_date += timedelta(days=32)  # Add more than a month, then set to the first day of that month
    current_date = current_date.replace(day=1)

# Save the result DataFrame to CSV
result_df = pd.DataFrame(results, columns=['YearMonth', 'Country', 'MadianDateDiff', 'Count'])
result_df.to_csv('figure2_results.csv', index=False)

print("Data processing complete and saved to median_results.csv.")