-- Task 6.2: Compare each row to its neighbors

-- Part A
-- Is a producer’s metric going up or down over time, not just high or low overall? For each event, show
-- the metric from the previous event and the next event, in time order.
-- Requirement: WITH, SELECT, LAG, LEAD, PARTITION BY, ORDER BY, WHERE
WITH rating_trends AS (
    SELECT
        movie_id,
        score,
        rated_at,
        LAG(score) OVER (PARTITION BY movie_id ORDER BY rated_at) AS previous_score,
        LEAD(score) OVER (PARTITION BY movie_id ORDER BY rated_at) AS next_score
    FROM ratings
)
SELECT
    movie_id,
    rated_at,
    score,
    previous_score,
    next_score,
    score - previous_score AS delta
FROM rating_trends
WHERE movie_id = 1
ORDER BY rated_at;

-- Part B: Cumulative and smoothed
-- How is the platform doing over time, both in total and on a recent average? Leadership wants to see where
-- things stand now and how they got there.
-- Requirement: SELECT, SUM, AVG, ORDER BY, ROWS BETWEEN
SELECT
    rated_at,
    score,
    SUM(score) OVER (ORDER BY rated_at ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total,
    AVG(score) OVER (ORDER BY rated_at ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS moving_average,
    600 AS target,
    600 - SUM(score) OVER (ORDER BY rated_at ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS remaining_to_target
FROM ratings
ORDER BY rated_at;

-- A target of 600 was chosen because it is closer to the running total of 569.3.

-- One or two sentences on how ROWS differs from RANGE when two rows have the same ORDER BY value.
-- ROWS count the number of physical rows, while RANGE refers to the frame by value. If two rows have the same
-- ORDER BY value, RANGE includes both rows in the same window frame, while ROWS treats them separately.


-- Part C: Where the series stops
-- One producer stops for a while and then starts again. Find that gap. Then think about what you cannot tell
-- yet: did the producer leave, or did your data lose them?
-- Requirement: WITH, SELECT, LAG, PARTITION BY, ORDER BY, WHERE
WITH rating_gaps AS (
    SELECT
        movie_id,
        rated_at AS current_timestamp,
        LAG(rated_at) OVER (PARTITION BY movie_id ORDER BY rated_at) AS previous_timestamp
    FROM ratings
)
SELECT
    movie_id,
    previous_timestamp,
    current_timestamp,
    current_timestamp - previous_timestamp AS gap
FROM rating_gaps
WHERE current_timestamp - previous_timestamp > INTERVAL '30 days'
ORDER BY gap DESC;