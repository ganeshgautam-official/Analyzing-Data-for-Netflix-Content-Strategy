-- =============================
-- Data Cleaning & Transformation
-- =============================

-- 1. Checking for duplicate records in the title_basics table
SELECT DISTINCT tconst, COUNT(tconst) AS count
FROM `cleaned_imdb_data.title_basics_cleaned`
GROUP BY tconst
ORDER BY count DESC
LIMIT 5;

-- 2. Cleaning title_basics table
--    - Handles '\N' values by replacing them with NULL or appropriate defaults
--    - Converts necessary fields to appropriate data types
CREATE OR REPLACE VIEW cleaned_imdb_data.title_basics_cleaned AS
SELECT
  tconst,
  titleType,
  primaryTitle,
  originalTitle,
  CAST(isAdult AS BOOL) AS isAdult,
  CASE WHEN startYear = '\N' THEN NULL ELSE CAST(startYear AS INT64) END AS startYear,
  CASE WHEN endYear = '\N' THEN NULL ELSE CAST(endYear AS INT64) END AS endYear,
  CASE WHEN runtimeMinutes = '\N' THEN NULL ELSE CAST(runtimeMinutes AS INT64) END AS runtimeMinutes,
  CASE WHEN genres = '\N' THEN 'Unspecified' ELSE genres END AS genres
FROM `staging_imdb_data.raw_title_basics`;

-- 3. Normalizing genres: Splitting multiple genres into separate rows
CREATE OR REPLACE VIEW cleaned_imdb_data.title_genre_cleaned AS
SELECT
  tconst,
  genre
FROM `cleaned_imdb_data.title_basics_cleaned`,
  UNNEST(SPLIT(genres, ',')) AS genre;

-- 4. Cleaning title_ratings table
--    - Converts averageRating and numVotes to appropriate numeric types
CREATE OR REPLACE VIEW cleaned_imdb_data.title_ratings_cleaned AS
SELECT
  tconst,
  CAST(averageRating AS FLOAT64) AS averageRating,
  CAST(numVotes AS INT64) AS numVotes
FROM `staging_imdb_data.raw_title_ratings`;

-- 5. Cleaning title_akas table
--    - Removes irrelevant columns
--    - Handles '\N' values by replacing them with 'Unspecified'
--    - Converts ordering and isOriginalTitle to appropriate data types
CREATE OR REPLACE VIEW cleaned_imdb_data.title_akas_cleaned AS
SELECT
  titleId,
  CAST(ordering AS INT64) AS ordering,
  title,
  CASE WHEN region = '\N' THEN 'Unspecified' ELSE region END AS region,
  CASE WHEN language = '\N' THEN 'Unspecified' ELSE language END AS language,
  CAST(isOriginalTitle AS BOOL) AS isOriginalTitle
FROM `staging_imdb_data.raw_title_akas`;

-- 6. Checking unique categories in title_principals table
SELECT DISTINCT category FROM `staging_imdb_data.raw_title_principals`;

-- 7. Cleaning title_principals table
--    - Filters unnecessary columns
--    - Converts ordering to INT64
CREATE OR REPLACE VIEW cleaned_imdb_data.title_principals_cleaned AS
SELECT
  tconst,
  CAST(ordering AS INT64) AS ordering,
  nconst,
  category
FROM `staging_imdb_data.raw_title_principals`;

-- 8. Cleaning name_basics table
--    - Handles '\N' values by replacing them with NULL or 'Not Provided'
--    - Converts birthYear and deathYear to INT64
CREATE OR REPLACE VIEW cleaned_imdb_data.name_basics_cleaned AS
SELECT
  string_field_0 AS nconst,
  CASE WHEN string_field_1 = '\N' THEN 'Not Provided' ELSE string_field_1 END AS primaryName,
  CASE WHEN string_field_2 = '\N' THEN NULL ELSE CAST(string_field_2 AS INT64) END AS birthYear,
  CASE WHEN string_field_3 = '\N' THEN NULL ELSE CAST(string_field_3 AS INT64) END AS deathYear
FROM `staging_imdb_data.raw_name_basics`;
