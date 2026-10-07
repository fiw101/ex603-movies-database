-- 3.1a Find movies (limit of 10) that are available and released after 2015
-- Sort by descending release year
-- Requirement: SELECT, WHERE, ORDER BY, LIMIT
SELECT movie_id, title, release_year
FROM movies
WHERE is_available = TRUE AND release_year > 2015
ORDER BY release_year DESC
LIMIT 10;


-- 3.1b Finds distinct rating statuses
-- 3 statuses: flagged, withdrawn, published
-- Requirement: SELECT, DISTINCT
SELECT DISTINCT rating_status
FROM ratings;


-- 3.1c Filter events in 2 different ways
-- Option 1: Query that filters a numeric range
-- Find ratings where between 25.0 and 30.0 minutes was watched
-- Requirement: SELECT, WHERE, BETWEEN
SELECT rating_id, user_id, movie_id, watch_minutes
FROM ratings
WHERE watch_minutes BETWEEN 25.0 AND 30.0;

-- Option 2: Query that filters using an explicit list of values with IN
-- Find ratings where the device country is either in the US or UK
-- Requirement: SELECT, WHERE, IN
SELECT rating_id, user_id, movie_id, device_country
FROM ratings
WHERE device_country IN ('US', 'UK');


-- 3.1d
-- Find movie titles that start with title_0
-- Requirement: SELECT, WHERE, LIKE
SELECT movie_id, movies.title
FROM movies
WHERE title LIKE '%Title_0%';

-- Find ratings that have a withdrawn reason as NULL and change it to 'No reason provided'
-- Requirement: SELECT, WHERE, IS NULL, COALESCE
SELECT rating_id, rating_status, COALESCE(withdrawn_reason, 'No reason provided') AS reason
FROM ratings
WHERE withdrawn_reason IS NULL;


-- 3.1e
-- Converted the rating score from 1.0 to 5.0 into 'Good', 'Average', and 'Bad'
-- to make it easier to understand
-- Requirement: SELECT, CASE
SELECT
    rating_id,
    score,
    CASE
        WHEN score > 3.0 THEN 'Good'
        WHEN score = 3.0 THEN 'Average'
        ELSE 'Bad'
    END AS rating_category
FROM ratings;