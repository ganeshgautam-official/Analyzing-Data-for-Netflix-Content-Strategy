## Project Overview  

This project analyzes publicly available data to help Netflix identify emerging trends and strategize its future movie content. The focus is on movies released between **2015 and 2024**, leveraging insights from:  

1. **IMDb Analysis**: Explore historical movie data to identify successful titles, genres, cast, directors, and movie length.  
2. **Facebook Audience Insights**: Validate the demographic details and geographic locations of target consumers.  
3. **Google Trends**: Identify global and regional trends and interests related to IMDB insights.  

The goal is to provide actionable insights for Netflix to create data-driven content that resonates with its audience.  




## **Business Case**  
### **Summary**  

This fictional case about the world’s largest subscription streaming service, **Netflix**, teaches how to use publicly available data and tools to explore data for interesting patterns that help answer important, key questions related to **movie content**.  

After years of providing key insights to Netflix, **Zach Joel** and his team of data analysts have the opportunity to give the streaming service new **movie** recommendations. The evening before Zach and his team begin digging into this challenge, he hopes to get a head start on the analysis by mining publicly available data. What insights could Zach and his team explore?  

### **Key Characters**  

- **Netflix**: Subscription-based streaming service that allows members to watch **movies** commercial-free on an internet-connected device.  
- **Zach Joel**: Manager and lead analyst for a data analytics team that consults with Netflix on various business operations and marketing challenges the global streaming service faces.  
- **Netflix Head of Content Marketing**: Executive charged with creating a strategy and vision for Netflix **movie content**, while developing and implementing strategies for delivering Netflix **movies** to subscribers.  
- **Google Trends**: Website that analyzes the popularity of top search queries in Google Search across various regions and languages.  
- **IMDb Datasets**: Subsets of IMDb data available for access to customers for personal and non-commercial use with information on millions of **movies**.  
- **Facebook Audience Insights**: Tool designed to help marketers learn more about their target audiences, including information about geography, demographics, purchase behavior, and more through anonymous and aggregated Facebook data.  

### **What’s the Next Big Thing for Netflix?**  

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

### **Your Assignment**  

Put yourself in Zach’s shoes. You’re hoping to glean high-level insights into the key questions you’ve agreed to explore for Netflix’s head of content marketing. Consider online self-service tools from Netflix’s digital platform partners – such as Google and Facebook – and open-source datasets from IMDb.  

Conduct an analysis of IMDb’s data files available for download to develop initial insights around questions related to historical **movies** and elements – cast, directors, genres, etc. – that appear to be correlated to success or failure of a **movie**. Consider using Facebook Audience Insights to validate the demographic details and geographic locations of target consumers. Next, use Google Trends to identify global and regional consumer trends and interests related to your initial insights.  

Your objective is to find interesting patterns that offer insights into your key questions. The output from this exercise should be a collection of exploratory, data-driven charts and tables that identify areas for further exploration and refinement as your data story takes shape.  

---  
**Source**: Adapted from the [Netflix Case Study](https://artscience.ai/netflix-case-study/), with a focus on **movies** instead of general titles.  


## **1. IMDb Movie Analysis: ELT Process Overview & Data Modeling**  

### **1.1 Extraction (E)**  
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

### **1.2 Loading (L)**  
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

### **1.3 Cleaning & Transformation (T)** 
All transformations performed **within BigQuery** using SQL.
For details on data cleaning and transformation, refer to [data_cleaning_&_transformation.sql](../Query/data_cleaning_&_transformation.sql)


**Data Pipeline: Staging → Cleaning → Transformation**


#### **1.3.1 Staging Layer**
- Raw IMDb datasets (`title.akas.tsv.gz`, `title.basics.tsv.gz`, `title.ratings.tsv.gz`, `title.principals.tsv.gz`, `name.basics.tsv.gz`) along with external data(`regionalCode_mapped`,  `languageCode_mapped`) are first loaded into **staging tables** in BigQuery:
  - `staging_imdb_data.raw_title_basics`
  - `staging_imdb_data.raw_title_akas`
  - `staging_imdb_data.raw_title_ratings`
  - `staging_imdb_data.raw_title_principals`
  - `staging_imdb_data.raw_name_basics`
  - `staging_imdb_data.regional_code_mapped`
  - `staging_imdb_data.language_code_mapped`

#### **1.3.2 Cleaning Steps (via BigQuery Views)** 
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
  -- Checked for duplicate records in each table.

#### **1.3.3 Data Transformation Step**  
Transformation involves **normalizing data**, enriching it with external tables, and preparing for analysis.  

##### **A. Genre Normalization**  
- Split comma-separated `genres` into a separate table. 
  

## **2. Data Modeling**  

### **2.1 Schema Design**  
**Fact Table**: `title_ratings` (Success Metrics)  
**Dimensions**: Title metadata, genres, cast, regions, and languages.   

---

### **2.2 Relationships**  
For detailed query refer to [data_modeling](/Query/data_modeling.sql) 
- **Star Schema**:  
  ![Star Schema Diagram](/Images/imdb_modeling.png)  
  - **Fact Table**: `title_ratings` (success metrics).  
  - **Dimensions**: Linked via foreign keys to analyze correlations.  

---

### **2.3 Pre-Joined Tables for Analysis**  
Materialized views were created to simplify correlation analysis in Tableau, for details refer to [prejoined_table](/Query/prejoined_table.sql) 



## 3. IMDb Historical Analysis

Explore the [Dashboard](https://public.tableau.com/app/profile/er.ganesh.gautam/viz/NetflixandAnalyzingDataforInsightsCaseStudy/AUDIENCE-) for detailed visualization of IMDB historical analysis. Navigate to the Historical analysis section to visualize regional and demographic insights.

---

### **3.1 Data Exploration & Key Findings**  
#### **Genre Popularity & Volume**  
- **Visual**: Bar chart (Genre vs. Volume) with color encoding for average popularity (votes)
    ![Genre Popularity](/Images/imdb/genre_popularity.png)
- **Key Insights**:  
  - **Drama**  and **Comedy** dominate in volume but have moderate popularity.  
  - **Action**, **Adventure**, and **Sci-Fi** genres have **significantly higher average votes** despite fewer titles.
  - **Focus Genres**: Action, Adventure, Sci-Fi (critical for success correlation analysis).
- Further analysis focuses on identifying the success factors contributing to the high popularity of the Action, Adventure, and Science Fiction genres with average rating at least 6.
    
---

#### **Runtime Impact on Popularity**  
   ![Runtime Popularity](/Images/imdb/runtime_analysis.png)
- **Calculated Field**: Runtime categorized into:
  - **Epic (141+ mins)**: Highest popularity (Adventure: 62.6K votes).  
  - **Extended (101-140 mins)**: 34% of total volume, high popularity (Sci-Fi: 63.8K votes).  
  - **Standard (61-100 mins)**: Highest volume (40%) but lower popularity.  
  - **Short (0-60 mins)**: Minimal volume and popularity (0.1K votes).
- **Epic (141+ min) and extended (101–140 min) movies are more popular than shorter films**.

---

### **3.2 Correlation Analysis**  
#### **Director Influence**  
- **Top 10 Popular Directors**:
  
  ![Director Popularity](/Images/imdb/top_director.png)  
- To explore other cast members, refer to [Dashboard](https://public.tableau.com/app/profile/er.ganesh.gautam/viz/NetflixandAnalyzingDataforInsightsCaseStudy/AUDIENCE-) & navigate to the IMDB Historical analysis section.
---

#### **Regional Popularity **  
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

To explore the popularity of all countries and languages, refer to [Dashboard](https://public.tableau.com/app/profile/er.ganesh.gautam/viz/NetflixandAnalyzingDataforInsightsCaseStudy/AUDIENCE-) & navigate to the IMDB Historical analysis section.

---

### **Key Success Factors**
1. **Genre Dominance**:  
   - **Action, Adventure, and Sci-Fi** are the **most popular genres** in terms of **average popularity**.  
   - These genres consistently attract a broad audience and drive higher engagement.  

2. **Runtime Length**:  
   - **Epic (141+ minutes)** and **Extended (101-140 minutes)** runtime lengths are the **most popular**.  
   - Audiences prefer **longer, immersive storytelling**, making these runtime lengths a key factor for success.  

3. **Regional and Language Insights**:  
   - **English**: Dominates in **North America, Oceania, and Africa**.  
   - **Japanese**: Key for **Eastern Asia**.  
   - **Spanish**: Vital for **South America**.  
   - Localizing content in these languages can significantly boost regional engagement.  

4. **Cast**:  
   - **Popular Directors**: Films directed by well-known directors (e.g., Russo Brothers, Denis Villeneuve) tend to perform better.  
   

---


## 4. Potential Audience by Demographics and Region
Explore the [Dashboard](https://public.tableau.com/app/profile/er.ganesh.gautam/viz/NetflixandAnalyzingDataforInsightsCaseStudy/AUDIENCE-) for detailed visualization of potential consumer audiences. Navigate to the Audience section to visualize regional and demographic insights.

### **Demographic Analysis (Age & Gender)**

#### **Audience Distribution by Region and Age Group (Men vs. Women)**

| Region              | 18-24 (M/W)       | 25-34 (M/W)       | 35-44 (M/W)       | 45-54 (M/W)       | 55-64 (M/W)       | 65+ (M/W)         |
|---------------------|-------------------|-------------------|-------------------|-------------------|-------------------|-------------------|
| **Africa**          | 10.4% / 8.4%      | **🔑 18.7%** /14.4% | 15.3% /10.8%      | 7.2% /4.6%        | 3.5% /2.5%        | 2.3% /1.9%        |
| **Southern Asia**   | 19.1% /4.4%       | **🔑 34.8%** /7.2%  | 18.2% /4.1%       | 5.6% /1.6%        | 2.4% /0.8%        | 1.3% /0.5%        |
| **Western Europe**  | 1.7% /1.0%        | 14.1% /8.6%       | 15.8% /12.0%      | 10.3% /9.6%       | 6.8% /8.5%        | 4.7% /6.9%        |
| **Southern Europe** | 1.3% /0.9%        | 9.5% /6.7%        | 12.2% /10.1%      | 11.9% /12.1%      | **🔑 8.1% /11.2%** | 6.7% /9.3%        |
| **Oceania**         | 3.2% /2.0%        | 13.5% /9.1%       | 13.5% /12.0%      | 8.0% /8.9%        | 5.9% /8.1%        | **🔑 6.1% /9.7%** |
| **SE Asia**         | 9.4% /6.9%        | 20.5% /15.6%      | 14.3% /11.9%      | 6.4% /6.2%        | 2.6% /3.1%        | 1.4% /1.7%        |
| **Northern Europe** | 1.6% /1.3%        | 11.1% /9.1%       | 12.7% /12.6%      | 8.8% /10.0%       | **🔑 7.0% /10.0%** | 6.1% /9.7%        |
| **Eastern Europe**  | 2.0% /2.1%        | 8.9% /9.3%        | 13.8% /13.3%      | 13.4% /10.8%      | 9.6% /5.8%        | 7.4% /3.6%        |
| **Eastern Asia**    | 7.0% /3.8%        | 18.5% /9.8%       | 14.2% /10.3%      | 10.7% /7.5%       | 7.5% /4.2%        | 4.4% /2.1%        |
| **Central Asia**    | 5.5% /3.3%        | 13.8% /10.0%      | 18.4% /14.3%      | 10.0% /9.3%       | 4.5% /5.9%        | 1.9% /3.1%        |
| **Western Asia**    | 7.0% /1.7%        | **🔑 23.8%** /7.1%  | 22.5% /8.6%       | 12.3% /4.9%       | 5.3% /2.7%        | 2.5% /1.6%        |
| **North America**   | 4.1% /4.7%        | 11.6% /11.9%      | 12.0% /11.1%      | 9.9% /8.1%        | 8.2% /5.6%        | 8.2% /4.6%        |
| **South America**   | 5.3% /4.5%        | 13.7% /12.2%      | 12.2% /12.9%      | 7.6% /9.9%        | 4.6% /7.7%        | 3.3% /6.1%        |

---

#### **Key Insights (Demographics):**
- **Key Age Group**: **Men 25-34** dominate in:  
   - **Southern Asia (34.8%)** – Highest engagement globally.  
   - **Western Asia (23.8%)** – Strong interest in Turkey/UAE.  
   - **Africa (18.7%)** – Significant interest in younger males.  
- **Key Gender**: **Women 55+** show peak engagement in:  
   - **Southern Europe (11.2%)** – Highest female engagement.  
   - **Northern Europe (10.0%)** – Strong interest in older women.  
   - **Oceania (9.7%)** – Notable interest among older females.  

---

### **Geographic Analysis (Cities & Countries)**

#### **Top Cities by Region**

| Region              | Top Cities (Percentage)                                                                 |
|---------------------|----------------------------------------------------------------------------------------|
| **Central Asia**    | Tashkent, Uzbekistan (21.66%), Almaty, Kazakhstan (13.74%), Astana, Kazakhstan (7.8%)  |
| **Eastern Asia**    | **🔑 Seoul, Korea (24.78%)**, Yokohama (6.04%), Busan, South Korea (4.4%)              |
| **Eastern Europe**  | Odessa, Ukraine (4.18%), Zaporizhia (3.86%), Bucharest, Romania (3.77%)               |
| **Northern Europe** | **🔑 London, United Kingdom (6.13%)**, Sheffield (1.55%), Birmingham, United Kingdom (1.42%) |
| **South America**   | Bogotá, Colombia (5.57%), Lima, Peru (5.12%), Santiago, Chile (3.16%)                 |
| **North America**   | **🔑 Mexico City, Mexico (6.73%)**, Ecatepec de Morelos (2.29%), Zapopan (1.72%)      |
| **SE Asia**         | Bangkok, Thailand (6.08%), Jakarta, Indonesia (4.14%), Manila, Philippines (3.1%)     |
| **Oceania**         | **🔑 Melbourne, Victoria, Australia (12.93%)**, Sydney, Australia (12.91%), Perth (6.79%) |
| **Southern Europe** | Madrid, Spain (2.95%), Rome, Italy (2.66%), Belgrade, Serbia (1.78%)                  |
| **Western Europe**  | Paris, France (3.59%), Berlin, Germany (2.18%), Hamburg, Germany (1.39%)              |
| **Southern Asia**   | **🔑 Delhi, India (6.47%)**, Mumbai, Maharashtra (3.65%), Kolkata (3.58%)             |
| **Africa**          | **🔑 Cairo, Egypt (25.13%)**, Alexandria, Egypt (9.31%), Port Said, Egypt (4.26%)     |
| **Western Asia**    | **🔑 Istanbul, Turkey (16.49%)**, Dubai, United Arab Emirates (15.46%), Abu Dhabi (5.28%) |

---

#### **Top Countries by Region**

| Region              | Top Countries (Percentage)                                                                 |
|---------------------|-------------------------------------------------------------------------------------------|
| **Central Asia**    | Kazakhstan (50.04%), Uzbekistan (49.96%)                                                 |
| **Eastern Asia**    | **🔑 South Korea (59.99%)**, Japan (39.35%), China (0.66%)                                |
| **Eastern Europe**  | Ukraine (27.93%), Romania (24.22%), Hungary (17.86%)                                     |
| **Northern Europe** | **🔑 United Kingdom (88.7%)**, Ireland (4.03%), Lithuania (3.14%)                        |
| **South America**   | Brazil (33.23%), Colombia (23.35%), Argentina (15.96%)                                   |
| **North America**   | **🔑 Mexico (54.15%)**, United States (40.3%), Canada (5.54%)                            |
| **SE Asia**         | Philippines (41.12%), Indonesia (39.62%), Thailand (18.36%)                              |
| **Oceania**         | **🔑 Australia (80.63%)**, New Zealand (19.37%)                                          |
| **Southern Europe** | Italy (38.18%), Spain (33.75%), Portugal (8.79%)                                         |
| **Western Europe**  | France (65.22%), Germany (31.26%), Austria (3.53%)                                       |
| **Southern Asia**   | **🔑 India (100%)**                                                                      |
| **Africa**          | **🔑 Egypt (81.45%)**, South Africa (18.55%)                                             |
| **Western Asia**    | **🔑 Turkey (63.69%)**, United Arab Emirates (29.92%), Israel (6.39%)                    |

---

### **Key Insights (Geographic):**
- **Key Cities**:  
   - **Cairo, Egypt (25.13%)** – Highest urban engagement globally.  
   - **Seoul, Korea (24.78%)** – Leading city in Eastern Asia.  
   - **Istanbul, Turkey (16.49%)** – Top city in Western Asia.  
- **Key Countries**:  
   - **India (100%)** – Total dominance in Southern Asia.  
   - **Egypt (81.45%)** – Highest country engagement in Africa.  
   - **Australia (80.63%)** – Leading country in Oceania.  

---

### **Recommendations for Targeting**

#### **4.1 High-Priority Focus (Highest Interest)**  
- **Regions**:  
  - **Southern Asia, Western Asia, Africa** – These regions show the **highest engagement** for **Men 25-34**.  
  - **Southern Europe, Northern Europe, Oceania** – These regions show the **highest engagement** for **Women 55+**.  
- **Demographics**:  
  - **Men 25-34**: Target in **Southern Asia (34.8%)**, **Western Asia (23.8%)**, and **Africa (18.7%)**.  
  - **Women 55+**: Target in **Southern Europe (11.2%)**, **Northern Europe (10.0%)**, and **Oceania (9.7%)**.  
- **Cities**:  
  - **Cairo, Egypt (25.13%)** – Highest urban engagement globally.  
  - **Seoul, Korea (24.78%)** – Leading city in Eastern Asia.  
  - **Istanbul, Turkey (16.49%)** – Top city in Western Asia.  
  - **Melbourne, Australia (12.93%)** – Leading city in Oceania.  
- **Countries**:  
  - **India (100%)** – Total dominance in Southern Asia.  
  - **Egypt (81.45%)** – Highest country engagement in Africa.  
  - **Australia (80.63%)** – Leading country in Oceania.  

---

#### **4.2 Moderate-Priority Focus (Balanced Interest)**  
- **Regions**:  
  - **Eastern Asia, North America, South America** – These regions show **moderate engagement** across multiple age groups.  
- **Demographics**:  
  - **Men 25-34**: Target in **Eastern Asia (18.5%)**, **North America (11.6%)**, and **South America (13.7%)**.  
  - **Women 35-44**: Target in **Eastern Europe (13.3%)** and **South America (12.9%)**.  
- **Cities**:  
  - **Mexico City, Mexico (6.73%)** – Leading city in North America.  
  - **Bogotá, Colombia (5.57%)** – Leading city in South America.  
  - **Bangkok, Thailand (6.08%)** – Leading city in South-eastern Asia.  
- **Countries**:  
  - **South Korea (59.99%)** – Leading country in Eastern Asia.  
  - **Mexico (54.15%)** – Leading country in North America.  
  - **Brazil (33.23%)** – Leading country in South America.  

---

#### **4.3 Low-Priority Focus (Lower Interest)**  
- **Regions**:  
  - **Central Asia, Eastern Europe, Western Europe** – These regions show **lower engagement** but still have potential in specific demographics.  
- **Demographics**:  
  - **Men 35-44**: Target in **Central Asia (18.4%)** and **Eastern Europe (13.8%)**.  
  - **Women 45-54**: Target in **Western Europe (9.6%)** and **Eastern Europe (10.8%)**.  
- **Cities**:  
  - **Tashkent, Uzbekistan (21.66%)** – Leading city in Central Asia.  
  - **Odessa, Ukraine (4.18%)** – Leading city in Eastern Europe.  
  - **Paris, France (3.59%)** – Leading city in Western Europe.  
- **Countries**:  
  - **Kazakhstan (50.04%)** – Leading country in Central Asia.  
  - **Ukraine (27.93%)** – Leading country in Eastern Europe.  
  - **France (65.22%)** – Leading country in Western Europe.  

---




## 5. Trend Analysis

### **Google Search Trends for Action, Adventure, and Science Fiction**

![Google Search Trends](/Images/imdb/google_search_trend.png) 
#### **5.1 Trend Year for Action, Adventure, and Science Fiction**
- **Action**: **2017**  
- **Adventure**: **2018**  
- **Sci-Fi**: **2015**  
  

---

### **IMDB Runtime Length Trends**

![IMDB Runtime Trends](/Images/imdb/imdb_runtime_trend.png)
#### **5.2 Runtime Length Trend**
- **Epic (141+ minutes)** and **Extended (101-140 minutes)** runtime lengths have consistently **surpassed other runtime categories** in popularity over the years.  
- Movies with **101+ minutes** are showing the most popularity and dominating the trend.
---


 ## 6. Insights

### **Answer to the key questions**

---

#### **1. What Movies Had Been Produced in the Past That Were Related to That Trend?**

The **IMDb historical analysis** and **Google search trends** indicate that **Action, Adventure, and Sci-Fi** are trending genres, with **Epic (141+ minutes)** and **Extended (101-140 minutes)** runtime lengths gaining higher popularity. Below is the list of titles featuring trending genres in their peak years:

#### **Action (Peak Year: 2017)**

![Action titles](/Images/imdb/action_titles.png)

#### **Adventure (Peak Year: 2018)**

![Adventure titles](/Images/imdb/adventure_titles.png)

#### **Sci-Fi (Peak Year: 2015)**

![sci-fi titles](/Images/imdb/sci-fi_titles.png)

---

#### **2. Why Were Some Movies Successful While Others Weren’t?**

1. **Top Genres Drive Popularity**:  
   - **Action, Adventure, and Sci-Fi** have the highest average votes and long-term popularity.  
   - Combining these genres attracts a broad audience and maximizes engagement.  

2. **Longer Movies Gain Higher Popularity**:  
   - **Epic (141+ minutes)** and **Extended (101-140 minutes)** runtime lengths are more popular than shorter films.  
   - Audiences prefer immersive storytelling, making longer movies a better investment.  

3. **Popular Cast Members Boost Success**:  
   - Movies featuring well-known directors receive significantly higher engagement.  
   - Casting popular directors can drive higher viewership and success.  

4. **Non-Adult Movies Dominate Popularity**:  
   - **99.9% of movies are non-adult**, contributing to **98.7% of total audience engagement**.  
   - Mainstream, family-friendly content reaches the widest audience and performs best.  

| Is Adult | Avg Popularity | Title Count |
|----------|----------------|-------------|
| False    | 2,953          | 99,885      |
| True     | 37             | 86          |

---

#### **3. Where (in Terms of Regions or Countries) Would a New Title Associated with That Topic Draw the Most Interest from Consumers?**

For regional and demographic insights, refer to the **4. Potential Audience by Demographics and Region** in the analysis:  
