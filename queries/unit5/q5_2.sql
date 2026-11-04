-- Task 5.2: Find Records That Joins May Exclude

-- Part A: Compare INNER JOIN and LEFT JOIN

-- 1. Use LEFT JOIN to return all producers, including those who have never had an event.
-- Requirement: SELECT, LEFT JOIN, ORDER BY
SELECT
    m.movie_id,
    m.title,
    r.user_id,
    r.score,
    r.rated_at
FROM movies m
LEFT JOIN ratings r ON m.movie_id = r.movie_id
ORDER BY m.movie_id;

-- 2. Write an equivalent query using INNER JOIN.
-- Requirement: SELECT, INNER JOIN, ORDER BY
SELECT
    m.movie_id,
    m.title,
    r.user_id,
    r.score,
    r.rated_at
FROM movies m
INNER JOIN ratings r ON m.movie_id = r.movie_id
ORDER BY m.movie_id;

-- 3. Compare the results and determine how many producers are excluded by the inner join.
-- The LEFT JOIN query returned 202 rows, while the INNER JOIN returned 200 rows. Therefore,
-- the INNER JOIN excluded 2 movies: Title_14 and Title_15 because these movies do not have
-- matching records in the rating table. .

-- 4. Explain which producers are missing and why.
-- Title_14 and Title_15 are missing from the INNER JOIN results. This means there are no matching
-- rating records for those movies, so user_id, score, and rated_at show as NULL on the LEFT JOIN results.
-- INNER JOIN only shows the matching records between movies and ratings, and Title_14 and Title_15
-- do not satisfy that.


-- Part B: Explore RIGHT JOIN and FULL OUTER JOIN

-- 1. Write a RIGHT JOIN that returns the same records as your LEFT JOIN from Part A.
-- Requirement: SELECT, RIGHT JOIN, ORDER BY
SELECT
    m.movie_id,
    m.title,
    r.user_id,
    r.score,
    r.rated_at
FROM ratings r
RIGHT JOIN movies m ON r.movie_id = m.movie_id
ORDER BY m.movie_id;


-- 2. Compare the results to confirm that they match.
-- Requirement: SELECT, LEFT JOIN, RIGHT JOIN, EXCEPT
(
    SELECT
        m.movie_id,
        m.title,
        r.user_id,
        r.score,
        r.rated_at
    FROM movies m
    LEFT JOIN ratings r ON m.movie_id = r.movie_id
)
EXCEPT
(
    SELECT
        m.movie_id,
        m.title,
        r.user_id,
        r.score,
        r.rated_at
    FROM ratings r
    RIGHT JOIN movies m ON r.movie_id = m.movie_id
);

(
    SELECT
        m.movie_id,
        m.title,
        r.user_id,
        r.score,
        r.rated_at
    FROM movies m
    RIGHT JOIN ratings r ON m.movie_id = r.movie_id
)
EXCEPT
(
    SELECT
        m.movie_id,
        m.title,
        r.user_id,
        r.score,
        r.rated_at
    FROM ratings r
    LEFT JOIN movies m ON r.movie_id = m.movie_id
);
-- Both the LEFT JOIN and RIGHT JOIN queries return 202 rows. This was also confirmed using EXCEPT,
-- showing that there are no differences between the results.

-- 3. Write a FULL OUTER JOIN that includes matching and unmatched records from both tables.
-- Requirement: SELECT, FULL OUTER JOIN, ORDER BY
SELECT
    m.movie_id,
    m.title,
    r.movie_id AS rated_movie_id,
    r.user_id,
    r.score,
    r.rated_at
FROM movies m
FULL OUTER JOIN ratings r ON m.movie_id = r.movie_id
ORDER BY m.movie_id;

-- 4. Explain what a full outer join can reveal that a left join or right join alone may not show.
-- Compared to a left or right join, a full outer join shows unmatched records from both tables.
-- In this case, the FULL OUTER JOIN includes the same movie and rating records as the LEFT JOIN
-- because every rating matches a movie.


-- Part C: Find Producers with No Events Using Two Approaches
-- Write two queries that identify producers who have never had an event and compare them.

-- NOT EXISTS
-- Requirement: SELECT, WHERE, NOT EXISTS, ORDER BY
SELECT
    m.movie_id,
    m.title
FROM movies m
WHERE NOT EXISTS (
    SELECT 1
    FROM ratings r
    WHERE r.movie_id = m.movie_id
)
ORDER BY m.movie_id;

-- EXCEPT
-- Requirement: SELECT, EXCEPT
SELECT movie_id, title
FROM movies

EXCEPT

SELECT
    m.movie_id,
    m.title
FROM movies m
JOIN ratings r ON m.movie_id = r.movie_id;

-- Explain how the approaches differ and confirm whether they identify the same producers.
-- NOT EXISTS returns the movies that don't have a rating associated with it, while EXCEPT subtracts
-- the list of movies from the list of movies with ratings to find the difference.
-- Both returned the same movie_id 14 and 15, which refers to Title_14 and Title_15.