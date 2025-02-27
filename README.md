# Project Overview  

This project analyzes publicly available data to help Netflix identify emerging trends and strategize its future movie content. The focus is on movies released between **2015 and 2024**, leveraging insights from:  

1. **IMDb Analysis**: Explore historical movie data to identify successful titles, genres, cast, directors, and movie length.  
2. **Facebook Audience Insights**: Validate the demographic details and geographic locations of target consumers.  
3. **Google Trends**: Identify global and regional trends and interests related to IMDB insights.  

The goal is to provide actionable insights for Netflix to create data-driven content that resonates with its audience.  




# **Business Case**  
## **Summary**  

This fictional case about the world’s largest subscription streaming service, **Netflix**, teaches how to use publicly available data and tools to explore data for interesting patterns that help answer important, key questions related to **movie content**.  

After years of providing key insights to Netflix, **Zach Joel** and his team of data analysts have the opportunity to give the streaming service new **movie** recommendations. The evening before Zach and his team begin digging into this challenge, he hopes to get a head start on the analysis by mining publicly available data. What insights could Zach and his team explore?  

## **Key Characters**  

- **Netflix**: Subscription-based streaming service that allows members to watch **movies** commercial-free on an internet-connected device.  
- **Zach Joel**: Manager and lead analyst for a data analytics team that consults with Netflix on various business operations and marketing challenges the global streaming service faces.  
- **Netflix Head of Content Marketing**: Executive charged with creating a strategy and vision for Netflix **movie content**, while developing and implementing strategies for delivering Netflix **movies** to subscribers.  
- **Google Trends**: Website that analyzes the popularity of top search queries in Google Search across various regions and languages.  
- **IMDb Datasets**: Subsets of IMDb data available for access to customers for personal and non-commercial use with information on millions of **movies**.  
- **Facebook Audience Insights**: Tool designed to help marketers learn more about their target audiences, including information about geography, demographics, purchase behavior, and more through anonymous and aggregated Facebook data.  

## **What’s the Next Big Thing for Netflix?**  

The solution was clear for Zach Joel, even if the answer wasn’t.  

Zach had spent the last five years leading a team of data analysts who worked with Netflix. They provided the over-the-top content platform and production company with valuable insights that contributed to Netflix’s success. Their work helped Netflix evaluate marketing campaigns, make budgeting decisions, and optimize the creative messages in its advertising. Netflix’s data-driven culture and sophisticated approach to digital marketing made the platform a collaborative and trusting partner that was always open to recommendations from Zach and his team.  

Zach consistently recommended robust data analysis as the solution to Netflix’s challenges. Netflix maintained a tremendous amount of consumer data. In addition, Netflix tapped data from its marketing partners (including Facebook, Google, and Twitter), data vendors, and open-source data cooperatives. Zach and his team mined this data regularly to answer Netflix’s biggest questions.  

As the world’s largest subscription streaming service with nearly 200 million paid subscribers worldwide, Netflix understood that the only way it would stay on top of its highly competitive market was to align the **movies** it produced and distributed to consumer interests. It wasn’t a surprise when Netflix’s head of content marketing asked if Zach and his team could pull together some thoughts on consumer interest trends that would present opportunities for Netflix. The ask didn’t come through a formal request, but rather during a conversation Zach and the head of content marketing had while sharing an elevator ride as the two left the Netflix office at the end of the day.  

**“What’s the next big thing, Zach?”** the executive wondered.  

Zach had already spent significant time thinking about this problem, so while he didn’t immediately know the answer, it wasn’t difficult for him to offer an approach that would yield ideas.  

Zach knew that gaining an understanding of global trends in consumer interest was an important first step. Providing Netflix with actionable insights, however, would require answers to a few other important questions. Specifically, after identifying an interesting trend, Netflix would need to know:  
1. What **movies** had been produced in the past that were related to that trend?  
2. Why were some **movies** successful while others weren’t?  
3. Where (in terms of regions or countries) would a new **movie** associated with that topic draw the most interest from consumers?  

As he sat at home that evening, Zach hoped to get a head start on the analysis by taking a spin through publicly available data sources. Zach had already planned his next several moves before his laptop whirled to life.  

## **Your Assignment**  

Put yourself in Zach’s shoes. You’re hoping to glean high-level insights into the key questions you’ve agreed to explore for Netflix’s head of content marketing. Consider online self-service tools from Netflix’s digital platform partners – such as Google and Facebook – and open-source datasets from IMDb.  

Conduct an analysis of IMDb’s data files available for download to develop initial insights around questions related to historical **movies** and elements – cast, directors, genres, etc. – that appear to be correlated to success or failure of a **movie**. Consider using Facebook Audience Insights to validate the demographic details and geographic locations of target consumers. Next, use Google Trends to identify global and regional consumer trends and interests related to your initial insights.  

Your objective is to find interesting patterns that offer insights into your key questions. The output from this exercise should be a collection of exploratory, data-driven charts and tables that identify areas for further exploration and refinement as your data story takes shape.  

---  
**Source**: Adapted from the [Netflix Case Study](https://artscience.ai/netflix-case-study/), with a focus on **movies** instead of general titles.  


# IMDb Movie Analysis: ELT Pipeline & Data Modeling  

## **ELT Process Overview**  

### **1. Extraction (E)**  
- **Source Data**:  
  - **IMDb Datasets**: Downloaded from [IMDb Non-Commercial Datasets](https://developer.imdb.com/non-commercial-datasets/).  
    - `title.akas.tsv.gz`, `title.basics.tsv.gz`, `title.ratings.tsv.gz`, `title.principals.tsv.gz`, `name.basics.tsv.gz`.  
  - **External Data**:  
    - ISO Country Codes (mapped to country name/region/subregion).  
    - Language Codes (mapped to language names).  
- **Tools**:  
  - Google Cloud Storage (GCS) for raw data storage.  
  - BigQuery for ELT workflows.  

---

### **2. Loading (L)**  
- Raw files uploaded to GCS buckets:  
  - `gs://<imdb_raw_data>/imdb/title_basics.tsv.gz`  
  - `gs://<imdb_raw_data>/imdb/title_akas.tsv.gz`
  - `gs://<imdb_raw_data>/imdb/title.ratings.tsv.gz`
  - `gs://<imdb_raw_data>/imdb/title.principals.tsv.gz`
  - `gs://<imdb_raw_data>/imdb/name.basics.tsv.gz`     
- External tables loaded directly into BigQuery:  
  - `regional_code_mapped` (country, region, subregion).  
  - `language_code_mapped` (language code, language name).  


---

### **3.Cleaning & Transformation (T)** 
All transformations performed **within BigQuery** using SQL.
For details on data cleaning and transformation, refer to [data_cleaning_&_transformation.sql](../Query/data_cleaning_&_transformation.sql)


**Data Pipeline: Staging → Cleaning → Transformation**


#### **1. Staging Layer**
- Raw IMDb datasets (`title.akas.tsv.gz`, `title.basics.tsv.gz`, `title.ratings.tsv.gz`, `title.principals.tsv.gz`, `name.basics.tsv.gz`) along with external data(`regionalCode_mapped`,  `languageCode_mapped`) are first loaded into **staging tables** in BigQuery:
  - `staging_imdb_data.raw_title_basics`
  - `staging_imdb_data.raw_title_akas`
  - `staging_imdb_data.raw_title_ratings`
  - `staging_imdb_data.raw_title_principals`
  - `staging_imdb_data.raw_name_basics`
  - `staging_imdb_data.regional_code_mapped`
  - `staging_imdb_data.language_code_mapped`

#### **2. Cleaning Steps (via BigQuery Views)** 
Views are created in the `cleaned_imdb_data` dataset to clean and transform raw staging tables:  

##### **A. Handling Missing Values**  
- Replace `\N` with `NULL` or descriptive placeholders (e.g., `'Unspecified'` for `genres`, `region`, `language`).    

##### **B. Typecasting Columns**  
- Convert columns to appropriate data types:  
  - `isAdult` → `BOOL`  
  - `averageRating` → `FLOAT64`  
  - `numVotes`, `runtimeMinutes`, `startYear` → `INT64`.  

##### **C. Data Validation**  
- **Deduplication**:  
  ```sql
  -- Checked for duplicate records in each table.

#### **3. Data Transformation Step**  
Transformation involves **normalizing data**, enriching it with external tables, and preparing for analysis.  

##### **A. Genre Normalization**  
- Split comma-separated `genres` into a separate table. 
  

## **Data Modeling & Correlation Analysis with Success Metrics**  

### **1. Schema Design**  
**Fact Table**: `title_ratings` (Success Metrics)  
**Dimensions**: Title metadata, genres, cast, regions, and languages.   

---

### **4. Relationships**  
For detailed query refer to [data_modeling](/Query/data_modeling.sql) 
- **Star Schema**:  
  ![Star Schema Diagram](/Images/imdb_modeling.png)  
  - **Fact Table**: `title_ratings` (success metrics).  
  - **Dimensions**: Linked via foreign keys to analyze correlations.  

---

### **5. Pre-Joined Tables for Analysis**  
Materialized views created to simplify correlation analysis in Tableau, for details refer to [prejoined_table](/Query/prejoined_table.sql) 

