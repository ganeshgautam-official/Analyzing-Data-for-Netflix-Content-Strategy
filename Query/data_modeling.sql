-- =============================
-- Data Modeling
-- =============================

-- 1. Dimension Tables

-- Basic information of movie titles (2015-2024)
CREATE OR REPLACE TABLE `cleaned_imdb_data.title_basics`
PARTITION BY RANGE_BUCKET(startYear, GENERATE_ARRAY(2015, 2024, 1))
CLUSTER BY tconst AS
SELECT
  tconst,
  titleType,
  primaryTitle,
  originalTitle,
  runtimeMinutes,
  isAdult,
  startYear
FROM `cleaned_imdb_data.title_basics_cleaned`
WHERE startYear BETWEEN 2015 AND 2024
  AND titleType = 'movie';

-- Regional and language information for titles
CREATE OR REPLACE TABLE `cleaned_imdb_data.title_akas`
CLUSTER BY titleId, region AS
SELECT
  titleId,
  ordering,
  title,
  region,
  language,
  isOriginalTitle
FROM `cleaned_imdb_data.title_akas_cleaned`
WHERE titleId IN (SELECT tconst FROM `cleaned_imdb_data.title_basics`);

-- Genre information per title
CREATE OR REPLACE TABLE `cleaned_imdb_data.title_genre`
CLUSTER BY tconst, genre AS
SELECT
  tconst,
  genre
FROM `cleaned_imdb_data.title_genre_cleaned`
WHERE tconst IN (SELECT tconst FROM `cleaned_imdb_data.title_basics`);

-- Movie cast information
CREATE OR REPLACE TABLE `cleaned_imdb_data.title_principals`
CLUSTER BY tconst, nconst AS
SELECT
  tconst,
  ordering,
  nconst,
  category
FROM `cleaned_imdb_data.title_principals_cleaned`
WHERE tconst IN (SELECT tconst FROM `cleaned_imdb_data.title_basics`);

-- Movie crew information
CREATE OR REPLACE TABLE `cleaned_imdb_data.name_basics`
CLUSTER BY nconst AS
SELECT
  nconst,
  primaryName,
  birthYear,
  deathYear
FROM `cleaned_imdb_data.name_basics_cleaned`
WHERE nconst IN (SELECT nconst FROM `cleaned_imdb_data.title_principals`);

-- Mapping regional codes to country, region, and sub-region
CREATE OR REPLACE TABLE `cleaned_imdb_data.regionalCode_mapped` AS
SELECT
  regional_code,
  country_name,
  region,
  sub_region
FROM `staging_imdb_data.regional_code_mapped`;

-- Mapping language codes to language names
CREATE OR REPLACE TABLE `cleaned_imdb_data.languageCode_mapped` AS
SELECT
  language_code,
  language_name
FROM `staging_imdb_data.language_code_mapped`;

-- 2. Fact Table

-- Quality & Popularity of titles (Success metrics)
CREATE OR REPLACE TABLE `cleaned_imdb_data.title_ratings`
CLUSTER BY tconst AS
SELECT
  tconst,
  averageRating,
  numVotes
FROM `cleaned_imdb_data.title_ratings_cleaned`
WHERE tconst IN (SELECT tconst FROM `cleaned_imdb_data.title_basics`);
