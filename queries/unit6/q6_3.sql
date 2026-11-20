-- Task 6.3: Build the reporting patterns

-- Part A: Top N per category
-- Return the top three events by metric for each producer.
-- Requirement: WITH, SELECT, JOIN, ROW_NUMBER(), PARTITION BY, ORDER BY, FIRST_VALUE, WHERE

WITH ranked_ratings AS (
    SELECT
        m.movie_id,
        m.title,
        r.user_id,
        r.score,
        r.rated_at,
        ROW_NUMBER() OVER (PARTITION BY m.movie_id ORDER BY r.score DESC, r.rating_id ASC) AS rating_rank,
        FIRST_VALUE(r.score) OVER (PARTITION BY m.movie_id ORDER BY r.score DESC, r.rating_id ASC) AS highest_score
    FROM movies m
    JOIN ratings r
    ON m.movie_id = r.movie_id
)
SELECT
    movie_id,
    title,
    user_id,
    score,
    rated_at,
    rating_rank,
    highest_score
FROM ranked_ratings
WHERE rating_rank <= 3
ORDER BY title, rating_rank;

-- Ties are broken using rating_id, so this query will show up to three ratings per movie.

-- Part B: Period over period
-- Is the platform getting better or worse each month?

WITH monthly_ratings AS (
    SELECT
        DATE_TRUNC('month', rated_at) AS month,
        COUNT(*) AS total_ratings,
        SUM(CASE
            WHEN withdrawn_reason = 'Spam detected' THEN 1
            ELSE 0
        END) AS total_failures
    FROM ratings
    GROUP BY DATE_TRUNC('month', rated_at)
),
monthly_comparison AS (
    SELECT
        month,
        total_ratings,
        total_failures,
        ROUND(
            100.0 * total_failures / NULLIF(total_ratings, 0), 2
        ) AS failure_rate,
        LAG(ROUND(
            100.0 * total_failures / NULLIF(total_ratings, 0), 2
        )) OVER (ORDER BY month) AS previous_month_rate,
        LAG(month) OVER (ORDER BY month) AS previous_month
    FROM monthly_ratings
)
SELECT
    month,
    total_ratings,
    total_failures,
    failure_rate,
    previous_month_rate,
    ROUND(100.0 * (failure_rate - previous_month_rate) / NULLIF(previous_month_rate, 0), 2) AS percent_change,
    CASE
        WHEN previous_month IS NULL
            THEN 'FIRST MONTH'
        WHEN month > previous_month + INTERVAL '1 month'
            THEN 'MISSING MONTH'
        ELSE 'CONTIGUOUS'
        END AS month_check
FROM monthly_comparison
ORDER BY month;
