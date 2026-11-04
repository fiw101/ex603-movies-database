-- Task 5.1: Connect Producers to Their Data

-- 1. Who are the people behind the events? Write a query that joins three tables to display the
-- actor who performed each event, the producer associated with the event, and the event's date
-- and time.
-- Requirement: SELECT, JOIN
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


-- 2. Do the producers identified in Assignment 4 share certain catalog credentials or tags? Write a
-- query that connects the producer table to the catalog table through the junction table. Return
-- the producers associated with your theme's catalog tag.
-- Requirement: SELECT, JOIN
SELECT
    m.movie_id,
    m.title,
    g.genre_name
FROM movies m
JOIN movie_genres mg ON m.movie_id = mg.movie_id
JOIN genres g ON mg.genre_id = g.genre_id
WHERE m.title IN ('Title_02', 'Title_03', 'Title_04');

-- The movies identified in assignment 4 were Title_02, Title_03, and Title_04. From the results, we can see
-- that Title_02 and Title_03 share Comedy, Title_02 and Title_04 share Drama, and Title_03 and Title_04 share Sci-Fi.


-- 3. How do the producers compare with one another? Write a self join to compare records within the
-- producer table. Use the results to explore whether the producers identified in Assignment 4
-- share characteristics with other producers or whether differences in activity levels may
-- explain their performance.
-- Requirement: SELECT, JOIN
SELECT
    m1.title AS movie_1,
    COUNT(DISTINCT r1.rating_id) AS ratings_1,
    m2.title AS movie_2,
    COUNT(DISTINCT r2.rating_id) AS ratings_2
FROM movies m1
JOIN movies m2 ON m1.movie_id < m2.movie_id
LEFT JOIN ratings r1 ON m1.movie_id = r1.movie_id
LEFT JOIN ratings r2 ON m2.movie_id = r2.movie_id
WHERE m1.title IN ('Title_02', 'Title_03', 'Title_04')
GROUP BY
    m1.movie_id, m1.title,
    m2.movie_id, m2.title
ORDER BY m1.title;

-- This query compares the three movies identified from Assignment 4 (Title_02, Title_03, Title_04) with
-- other movies and their rating count. Title_02 has 16 ratings, Title_03 has 13 ratings,
-- and Title_04 has 6 ratings. It is also seen that Title_02 and Title_11 both have 16 ratings. This shows
-- activity levels and number of ratings should be considered when looking at a movie's performance.