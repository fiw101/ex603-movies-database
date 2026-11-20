-- Task 6.1: Compute across a window without collapsing

-- 1. Compare each event to its producer’s average. Is an event unusual for its own producer? Return every
-- event with its producer’s average metric on the same row. Use AVG(...) OVER (PARTITION BY ...). Then write
-- the GROUP BY version and compare: how many rows does each return, and what is lost?
-- Requirement: SELECT, AVG() OVER (PARTITION BY ...), GROUP BY
SELECT
    movie_id,
    score,
    AVG(score) OVER (PARTITION BY movie_id) AS movie_avg
FROM ratings;

SELECT movie_id, AVG(score) AS movie_avg
FROM ratings
GROUP BY movie_id;

-- Using AVG(...) OVER (PARTITION BY ...) returns 200 rows, but using GROUP BY returns 13 rows. Using GROUP BY
-- loses the individual ratings for each movie.

-- 2. Rank producers by number of events using ROW_NUMBER(), RANK(), and DENSE_RANK(), side by side in one
-- query. Make sure your output shows at least one tie
-- Requirement: WITH, SELECT, COUNT(*), GROUP BY, ROW NUMBER(), RANK(), DENSE_RANK()
WITH movie_counts AS (
    SELECT
        movie_id,
        COUNT(*) AS rating_count
    FROM ratings
    GROUP BY movie_id
)
SELECT
    movie_id,
    rating_count,
    ROW_NUMBER() OVER (ORDER BY rating_count DESC, movie_id) AS row_num,
    RANK() OVER (ORDER BY rating_count DESC) AS rank,
    DENSE_RANK() OVER (ORDER BY rating_count DESC) AS dense_rank
FROM movie_counts;

-- 3. Sort producers into four bands. Use NTILE(4) to split producers into four groups by number of events.
-- Look at what happens when tied producers land on both sides of a group boundary.
-- Requirement: WITH, SELECT, COUNT(*), GROUP BY, NTILE
WITH movie_counts AS (
    SELECT
        movie_id,
        COUNT(*) AS rating_count
    FROM ratings
    GROUP BY movie_id
)
SELECT
    movie_id,
    rating_count,
    NTILE(4) OVER (ORDER BY rating_count DESC) AS movie_band
FROM movie_counts;

-- NTILE(4) means the results are divided into 4 equal groups. movie_id 2 and 11 both have a rating count of 16
-- but movie id 2 was put in movie band 2, while movie id 11 was put in movie band 3.