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
  

## **Data Modeling**  

### **1. Schema Design**  
**Fact Table**: `title_ratings` (Success Metrics)  
**Dimensions**: Title metadata, genres, cast, regions, and languages.   

---

### **2. Relationships**  
For detailed query refer to [data_modeling](/Query/data_modeling.sql) 
- **Star Schema**:  
  ![Star Schema Diagram](/Images/imdb_modeling.png)  
  - **Fact Table**: `title_ratings` (success metrics).  
  - **Dimensions**: Linked via foreign keys to analyze correlations.  

---

### **3. Pre-Joined Tables for Analysis**  
Materialized views were created to simplify correlation analysis in Tableau, for details refer to [prejoined_table](/Query/prejoined_table.sql) 



# IMDb Historical Analysis   
**Tableau Public Dashboard:** [IMDb Historical Analysis](https://public.tableau.com/app/profile/er.ganesh.gautam/viz/NetflixandAnalyzingDataforInsightsCaseStudy/AUDIENCE-) 

---

## **1. Data Exploration & Key Findings**  
### **Genre Popularity & Volume**  
- **Visual**: Bar chart (Genre vs. Volume) with color encoding for average popularity (votes)
    ![Genre Popularity](/Images/imdb/genre_popularity.png)
- **Key Insights**:  
  - **Drama** (24.9K titles) and **Comedy** dominate in volume but have moderate popularity.  
  - **Action**, **Adventure**, and **Sci-Fi** genres have **significantly higher average votes** despite fewer titles.
  - **Focus Genres**: Action, Adventure, Sci-Fi (critical for success correlation analysis).
- Further analysis focuses on identifying the success factors contributing to the high popularity of the Action, Adventure, and Science Fiction genres.
    
---

### **Runtime Impact on Popularity**  
   ![Runtime Popularity](/Images/imdb/runtime_analysis.png)
- **Calculated Field**: Runtime categorized into:
  - **Epic (141+ mins)**: Highest popularity (Adventure: 62.6K votes).  
  - **Extended (101-140 mins)**: 34% of total volume, high popularity (e.g., Sci-Fi: 63.8K votes).  
  - **Standard (61-100 mins)**: Highest volume (40%) but lower popularity.  
  - **Short (0-60 mins)**: Minimal volume and popularity (0.1K votes).
- **Epic (141+ min) and extended (101–140 min) movies are more popular than shorter films**.

---

## **2. Correlation Analysis**  
### **Director Influence**  
- **Top 10 Popular Directors**:
  
  ![Director Popularity](/Images/imdb/top_director.png)  
- To explore other cast members, refer to [IMDb Historical Analysis](https://public.tableau.com/app/profile/er.ganesh.gautam/viz/NetflixandAnalyzingDataforInsightsCaseStudy/AUDIENCE-)
---

### **Regional Popularity & Target Markets**  
- **Visual**: Heatmaps (green = high popularity, red = low) & bar charts for countries/languages.  
- **Global Trends**:  
  - **Top Countries**: USA (290M votes), UK (289.2M), Canada (281.1M).  
  - **Dominant Languages**: English (288.9M), Japanese (265.2M), French (258.1M).
    ![Director Popularity](/Images/imdb/regional_popularity.png)
    ![Director Popularity](/Images/imdb/countrywise_popularity.png)
    ![Director Popularity](/Images/imdb/languagewise_popularity.png)



#### **Subregion Breakdown**  
| Region               | Top Countries                            | Dominant Language(s)               |  
|----------------------|------------------------------------------|------------------------------------|  
| **Northern Europe**  | United Kingdom, Sweden, Lithuania       | English (177.3M)                    |  
| **Oceania**          | Australia, New Zealand                  | English (166M)                      |  
| **South America**    | Brazil, Argentina, Ecuador              | Spanish (258.5M)                    |  
| **South-eastern Asia**| Singapore, Philippines, Viet Nam       | English (242.5M)                    |  
| **Southern Asia**    | India, Iran, Bangladesh                 | Hindi (248.6M), English (268.1M)    |  
| **Southern Europe**  | Italy, Spain, Portugal                  | Catalan (56.9M)                     |  
| **Western Asia**     | Türkiye, Israel, United Arab Emirates   | Turkish (236.3M), Hebrew (168.8M)   |  
| **Africa**           | South Africa, Egypt                     | English (226.6M)                    |
| **Central Asia**     | Uzbekistan, Kazakstan                   | Russian (70.6M)                     |
| **Eastern Asia**     | Japan, Taiwan, Hong-Kong                | Japanese (265.2)                    |
| **Eastern Europe**   | Russia, Poland, Ukraine                 | Bulgarian (194M)                    |
| **North America**    | USA, Canada, Mexico                     | English (279.2M)                    |
| **Western Europe**   | Germany, France, Netherland             | French (29M), English(22.7)         |

To explore the popularity of all countries and languages, refer to [IMDb Historical Analysis](https://public.tableau.com/app/profile/er.ganesh.gautam/viz/NetflixandAnalyzingDataforInsightsCaseStudy/AUDIENCE-)

---

## **3. Success Metrics & Recommendations**  
### **Common Success Factors**  
1. **Genre Focus**: Prioritize **Action, Adventure, Sci-Fi** with **Extended/Epic runtimes**.  
2. **Director Partnerships**: Leverage top directors (Russo Brothers, Villeneuve).  
3. **Regional Localization**:  
   - **English**: Critical in North America, Oceania, and Africa.  
   - **Japanese**: Key for Eastern Asia.  
   - **Spanish**: Vital for South America.  

**Explore the dashboard here**: [IMDb Historical Analysis](https://public.tableau.com/app/profile/er.ganesh.gautam/viz/NetflixandAnalyzingDataforInsightsCaseStudy/AUDIENCE-).  



# Facebook Audience Insights for Action, Adventure, and Science Fiction Interest

## Demographical Audience Distribution by Region and Age Group

| Region              | 18-24            | 25-34            | 35-44            | 45-54            | 55-64            | 65+              |
|---------------------|------------------|------------------|------------------|------------------|------------------|------------------|
|                     | Men      Women   | Men      Women   | Men      Women   | Men      Women   | Men      Women   | Men      Women   |
|---------------------|----------|--------|----------|--------|----------|--------|----------|--------|----------|--------|----------|--------|
| Africa              | 10.4     8.4     | 18.7    14.4    | 15.3    10.8    | 7.2      4.6     | 3.5      2.5     | 2.3      1.9     |
| Southern Asia       | 19.1     4.4     | 34.8    7.2     | 18.2    4.1     | 5.6      1.6     | 2.4      0.8     | 1.3      0.5     |
| Western Europe      | 1.7      1.0     | 14.1    8.6     | 15.8    12.0    | 10.3     9.6     | 6.8      8.5     | 4.7      6.9     |
| Southern Europe     | 1.3      0.9     | 9.5     6.7     | 12.2    10.1    | 11.9     12.1    | 8.1      11.2    | 6.7      9.3     |
| Oceania             | 3.2      2.0     | 13.5    9.1     | 13.5    12.0    | 8.0      8.9     | 5.9      8.1     | 6.1      9.7     |
| South-eastern Asia  | 9.4      6.9     | 20.5    15.6    | 14.3    11.9    | 6.4      6.2     | 2.6      3.1     | 1.4      1.7     |
| Northern Europe     | 1.6      1.3     | 11.1    9.1     | 12.7    12.6    | 8.8      10.0    | 7.0      10.0    | 6.1      9.7     |
| Eastern Europe      | 2.0      2.1     | 8.9     9.3     | 13.8    13.3    | 13.4     10.8    | 9.6      5.8     | 7.4      3.6     |
| Eastern Asia        | 7.0      3.8     | 18.5    9.8     | 14.2    10.3    | 10.7     7.5     | 7.5      4.2     | 4.4      2.1     |
| Central Asia        | 5.5      3.3     | 13.8    10.0    | 18.4    14.3    | 10.0     9.3     | 4.5      5.9     | 1.9      3.1     |
| Western Asia        | 7.0      1.7     | 23.8    7.1     | 22.5    8.6     | 12.3     4.9     | 5.3      2.7     | 2.5      1.6     |
| North America       | 4.1      4.7     | 11.6    11.9    | 12.0    11.1    | 9.9      8.1     | 8.2      5.6     | 8.2      4.6     |
| South America       | 5.3      4.5     | 13.7    12.2    | 12.2    12.9    | 7.6      9.9     | 4.6      7.7     | 3.3      6.1     |
| **Average**         | **5.7    3.6**  | **16.7  10.1** | **14.9  11.2** | **8.9    7.9**  | **5.6    6.3**  | **4.0    4.7**  |

---

### Key Observations:
1. **Highest Male Interest**:  
   - **Southern Asia (Men 25-34)** has the highest male audience percentage at **34.8%**.  
   - **Western Asia (Men 25-34)** follows closely with **23.8%**.  

2. **Highest Female Interest**:  
   - **Southern Europe (Women 55-64)** has the highest female audience percentage at **11.2%**.  
   - **Northern Europe (Women 55-64 and 65+)** shows strong engagement at **10.0%** and **9.7%**, respectively.  

3. **Gender Disparity**:  
   - Male audiences dominate in younger age groups (18-44) across most regions, especially in **Southern Asia** and **Western Asia**.  
   - Female audiences are more prominent in older age groups (45+) in **Southern Europe**, **Northern Europe**, and **Oceania**.  

4. **Regional Trends**:  
   - **Western Europe** and **Northern Europe** have balanced gender distributions in older age brackets (55+).  
   - **Africa** and **Southern Asia** show significantly lower female engagement overall.  

Use this data to tailor marketing strategies by targeting high-engagement demographics (e.g., Men aged 25-34 in Southern/Western Asia) and addressing gaps in underrepresented groups (e.g., Women in Africa/Southern Asia).  
