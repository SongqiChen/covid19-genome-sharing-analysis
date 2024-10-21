# **covid19-genome-sharing-analysis**

This project contains the data processing steps and code for the GISAID database. For specific research details and conclusions, please refer to the following paper:

**Trends and Impacts of SARS-CoV-2 Genome Sharing: A Comparative Analysis of China and the Global Community, 2020-2023**  
Yenan Feng, Songqi Chen, Anqi Wang, Zhongfu Zhao, Cao Chen (Correspondence)

**[Link to the paper]**

## Contents
1. [Software Environment and Data Preprocessing](#software-environment-and-data-preprocessing)
2. [Statistical Analysis Code](#statistical-analysis-code)
3. [Figure Drawing](#figure-drawing)

## Software Environment and Data Preprocessing

### Software Environment

The project code was run on Win11, Docker Desktop v4.28.0 (139021), Docker Engine v25.0.3, MySQL v8.3.0, DataGrip 2023.3.4, conda 24.3.0, and Python 3.11.8.

### Data Download and Preprocessing

1. Visit the [GISAID official website](https://gisaid.org/), click the `Login` button in the upper right corner to log in. Then select `EpiCoV™ - Downloads`, and in the pop-up window under the **Download packages** category, find `metadata` and click to download.  
   Note: During code revisions, data sources extracted on 20241007 were used to cross-check those extracted on 20240401. It was found that the total amount of data increased, suggesting that GISAID had delayed data release. Specifically, between April and October 2024, data reported from 2020 to 2023 by multiple countries and regions were released. The downloaded metadata does not indicate when the data was approved and released, so please use the 20241007 data source version for replication as much as possible. If consistency cannot be ensured, discrepancies may occur for a few countries, though they should not significantly affect the results.
2. Deploy MySQL 8+ (deployed using Docker container in this study), then connect and create a database.
3. Use DataGrip or other database management software to import the downloaded TSV or CSV files from both databases into the database, keeping column names unchanged as much as possible (due to the large volume of data, this may take up to 10 minutes or more).  
   Note: During the import process, some records may fail due to the AA Substitutions field length exceeding MySQL's text type limit (encountered two records in the study). Since AA Substitutions is not discussed in this paper, the content was replaced in the next preprocessing step, and the failed records were manually inserted using SQL commands. Refer to this method to handle import failures based on your error messages.
4. After importing, you will get table "metadata_gisaid". Then, run the code in the SQL files in the preprocess folder to preprocess the data. The specific significance of each preprocessing step is described in the code comments.

## Statistical Analysis Code

1. Complete environment setup, data download, and preprocessing ([Software Environment and Data Preprocessing](#software-environment-and-data-preprocessing)).
2. Navigate to the corresponding folder under the analysis directory according to the figure number and open the SQL file.
3. Detailed execution steps and code are provided in the SQL file. Follow the comments in the file to proceed. If there is no SQL file, open the Python file and follow the comments.

## Figure Drawing

After completing data analysis, export the results as Excel or CSV files, then switch to the visualization folder and run the corresponding Python code. The dependencies required and explanations are provided in the file comments.

## License
Licensed under an MIT license.