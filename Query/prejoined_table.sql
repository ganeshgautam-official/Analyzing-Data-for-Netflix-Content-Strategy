
CREATE OR REPLACE TABLE `cleaned_imdb_data.title_success_analysis`
PARTITION BY RANGE_BUCKET(startYear, GENERATE_ARRAY(2015, 2024, 1))
CLUSTER BY tconst AS
SELECT
    r.tconst,
    b.primaryTitle,
    b.originalTitle,
    b.startYear,
    b.runtimeMinutes,
    b.isAdult,
    r.averageRating,
    r.numVotes,
    g.genre,
    p.nconst,
    p.category,
    n.primaryName AS cast_name,
    a.region AS regional_code,
    rc.country_name,
    rc.region,
    rc.sub_region,
    a.language as language_code,
    lc.language_name
FROM `cleaned_imdb_data.title_ratings` r
LEFT JOIN `cleaned_imdb_data.title_basics` b ON r.tconst = b.tconst
LEFT JOIN `cleaned_imdb_data.title_genre` g ON r.tconst = g.tconst
LEFT JOIN `cleaned_imdb_data.title_principals` p ON r.tconst = p.tconst
LEFT JOIN `cleaned_imdb_data.name_basics` n ON p.nconst = n.nconst
LEFT JOIN `cleaned_imdb_data.title_akas` a ON r.tconst = a.titleId
LEFT JOIN `cleaned_imdb_data.regionalCode_mapped` rc ON a.region = rc.regional_code
LEFT JOIN `cleaned_imdb_data.languageCode_mapped` lc ON a.language = lc.language_code;
