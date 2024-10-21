# Import csv and statistics modules for reading and processing data
import csv
import statistics
import sys

# Set to figure1_gisaid.sql step
input_file_name = 'datediff_2020.csv'
# Read the csv file content
with open(input_file_name, 'r', encoding='utf-8') as f:
    reader = csv.reader(f, delimiter=',')

    # Read the header
    header = next(reader)
    numbers = header[1:]

    # Create a list of columns to skip, including Country, TOTAL columns, and all negative columns (incomplete dates or submission dates earlier than sampling dates)
    skip_column = []
    for j in range(0, len(header)):
        if header[j] is None or header[j] == 'Country' or header[j] == 'TOTAL' or int(header[j]) < 0:
            skip_column.append(j)

    # Read the remaining rows
    rows = list(reader)
    total_rows = len(rows)

    # Create a dictionary to store data for each country
    data = {}

    # Iterate over each country
    for i, row in enumerate(rows):
        # Get the name of the country, used as the key in the dictionary
        country = row[0].replace('ô', 'o').replace("ç", "c")

        # Store all the numbers for this country
        values = []

        # Calculate the current processing progress
        progress = (i + 1) / total_rows
        percentage = f'{progress * 100:.2f}%'
        bar = '#' * int(progress * 20) + '-' * (20 - int(progress * 20))

        # Display the current processing progress in the terminal
        sys.stdout.write(f'\r{percentage} [{bar}]   Processing row {i + 1} of {total_rows}, Country: {country.ljust(35)}')
        sys.stdout.flush()

        # Iterate over each column, each column representing the count of a number
        for j in range(1, len(row)):
            # If the current column is in the skip column range, move to the next iteration
            if j in skip_column:
                continue
            # Number of occurrences (i.e., sequence count)
            count = int(row[j])

            # Get the specific value (i.e., the difference between submission and sampling dates)
            number = numbers[j - 1]

            # Add this number to the values list repeatedly according to its count
            for _ in range(count):
                values.append(int(number))

        # Sort the values list in ascending order
        values.sort()

        # Calculate the sum of all numbers
        total = sum(values)

        # Calculate the sequence count
        count = len(values)

        # If the sum is 0 and the sequence count is 0, it means no valid sequences were submitted by this country (skip to avoid subsequent calculation errors)
        if total == 0 and count == 0:  # cutoff
            continue

        # Calculate the median
        median = statistics.median(values)

        # Calculate the mean
        mean = statistics.mean(values)

        # Calculate the expected value
        expectation = statistics.fmean(values)

        # Calculate quartiles (ensure there are at least 4 sequences)
        if count >= 4:
            quartiles = statistics.quantiles(values, n=4, method='inclusive')
            # First quartile and third quartile
            q1 = quartiles[0]
            q3 = quartiles[2]
        else:
            q1 = None
            q3 = None

        # Calculate the standard deviation
        stdev = statistics.pstdev(values)

        # Calculate the variance
        variance = statistics.pvariance(values)

        # Calculate the mode, if there are multiple, concatenate them with commas
        try:
            mode = statistics.mode(values)
        except statistics.StatisticsError:
            mode = None
        else:
            modes = statistics.multimode(values)
            if len(modes) > 1:
                mode = ','.join(str(m) for m in modes)

        # Store all calculation results for this country in a list, used as the value in the dictionary
        data[country] = [count, mean, expectation, mode, q1, median, q3, stdev, variance, total]

# Create a new csv file to save the calculation results
output_file_name = 'output_' + input_file_name
with open(output_file_name, 'w', encoding='gbk', newline='') as f:
    writer = csv.writer(f, delimiter='\t')

    # Write the first row, explaining the meaning of each column, using both Chinese and English
    writer.writerow(
        ['国家(Country)', '总数(Count)', '平均值(Mean)', '数学期望(Expectation)', '众数(Mode)', '四分之一中位数(Q1)',
         '中位数(Median)', '四分之三中位数(Q3)', '标准差(Stdev)', '方差(Variance)', '总和(Total)'])

    # Iterate over the data dictionary and write each row of data
    for i, (country, values) in enumerate(data.items()):
        progress = (i + 1) / len(data)
        percentage = f'{progress * 100:.2f}%'
        bar = '#' * int(progress * 20) + '-' * (20 - int(progress * 20))

        sys.stdout.write(f'\r{percentage} [{bar}]   Writing row {i + 1} of {len(data)}, Country: {country.ljust(35)}')
        sys.stdout.flush()

        writer.writerow([country] + values)

# Print completion message
print(f'\nProgram finished, results have been saved in {output_file_name}.')

# The data in the file ultimately only uses Country, Count, and Median. After completing the calculations for the years 2020-2023, the combined data is used for plotting.
