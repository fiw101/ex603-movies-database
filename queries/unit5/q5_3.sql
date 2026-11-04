-- Task 5.3: Understand Join Performance and Execution Plans

-- Part A: Explore CROSS JOIN

-- 1. Count the rows in each source table.
-- Requirement: SELECT
-- Count movies
SELECT COUNT(*) AS movie_count
FROM movies;

-- Row count: 15

-- Count genres
SELECT COUNT(*) AS genre_count
FROM genres;

-- Row count: 5

-- 2. Run the CROSS JOIN and count the resulting rows.
-- Requirement: SELECT, CROSS JOIN
SELECT COUNT(*)
FROM movies m
CROSS JOIN genres g;
-- There are 75 rows after performing a CROSS JOIN between movies and genres.

-- 3. Show how the result matches the multiplication of the two source table counts.
-- As calculated in Part A #1, there are 15 movies and 5 genres. 15 x 5 = 75, which matches the
-- number of rows in the cross join result.

-- 4. Explain when a Cartesian product might be useful and when it could indicate a query error.
-- A Cartesian product is useful to show all possible combination results, but it could cause a
-- query error if a join condition is missed.


-- Part B: Examine a Query Execution Plan

-- 1. Capture the full execution plan.
-- REQUIREMENT: EXPLAIN, SELECT, JOIN
EXPLAIN
SELECT
    u.user_id,
    u.user_name,
    m.movie_id,
    m.title,
    r.score,
    r.rated_at
FROM ratings r
JOIN users u ON r.user_id = u.user_id
JOIN movies m ON r.movie_id = m.movie_id;

-- 2. Identify the join algorithm or algorithms used, such as Nested Loop, Hash Join, or Merge Join.
-- A hash join is used to join rating and users, and a nested loop is used to join the results with movies.

-- 3. Explain why PostgreSQL may have selected these algorithms, considering table sizes and available indexes.
-- Hash join can match ratings and users quickly using user id. Then, nested loop used the index
-- movie_id to find matching movies faster.

-- 4. Predict which part of the query might become less efficient as the dataset grows.
-- As the dataset grows, the hash join between ratings and users might become less efficient because more
-- records need to be matched.
