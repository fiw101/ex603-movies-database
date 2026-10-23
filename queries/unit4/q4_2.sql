-- Part A:

-- For each producer, compute the total number of events and the total number of events
-- classified as failures, in a single pass over the event table, without a WHERE clause
-- filtering the whole query.
-- Requirement: SELECT, COUNT, SUM, CASE, LEFT JOIN, GROUP BY

SELECT m.movie_id, m.title,
    COUNT(r.rating_id) AS total_ratings,
    SUM(CASE WHEN r.withdrawn_reason = 'Spam detected' THEN 1 ELSE 0 END) AS total_failures
FROM movies m
LEFT JOIN ratings r ON m.movie_id = r.movie_id
GROUP BY m.movie_id, m.title
ORDER BY total_failures DESC, total_ratings ASC;

-- The outliers can be determined using the failure rate, which includes Title_02 with 3 of 16
-- marked as spam detected, as well as Title_03 and Title_04.


-- Part B:

-- Write a query that produces regional subtotals and a platform-wide grand total without
-- including the individual detail rows.
-- Requirement: SELECT, COUNT, SUM, CASE, JOIN, GROUP BY ROLLUP

SELECT
    r.device_country AS country,
    COUNT(r.rating_id) AS total_ratings,
    SUM(CASE WHEN r.withdrawn_reason = 'Spam detected' THEN 1 ELSE 0 END) AS total_failures
FROM movies m
JOIN ratings r ON m.movie_id = r.movie_id
GROUP BY ROLLUP (r.device_country);

-- The first row with NULL region, 200 total ratings, and 12 total failures represents the
-- grand total. The subtotals are the remaining rows with the country name.

-- Part C:
-- Calculate a baseline for high-volume producers: use a WITH clause to create an
-- intermediate result that summarizes performance for each producer, then use a second
-- aggregation or filter on that intermediate result

WITH performance_summary AS (
    SELECT
        m.movie_id,
        m.title,
        COUNT(r.rating_id) AS total_ratings,
        SUM(CASE WHEN r.withdrawn_reason = 'Spam detected' THEN 1 ELSE 0 END) AS total_failures
    FROM movies m
    LEFT JOIN ratings r ON m.movie_id = r.movie_id
    GROUP BY m.movie_id, m.title
)
SELECT
    AVG(total_ratings) AS avg_ratings_baseline,
    AVG(total_failures) AS avg_failures_baseline,
    MAX(total_ratings) AS max_ratings
FROM performance_summary
WHERE total_ratings >= 15;

-- Result:
-- Average rating: 18.125, average failures: 0.875, max ratings: 21
