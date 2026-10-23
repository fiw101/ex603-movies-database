-- Task 4.1: Measure the platform

-- 1. Calculate the following statistics across the entire event table using your theme's
-- metric: the count, total, average, minimum, and maximum of your theme’s metric across
-- the whole event table, and how many distinct actors appear.
-- Requirement: SELECT, COUNT, SUM, AVG, MIN, MAX, COUNT DISTINCT

SELECT
    COUNT(*) AS count,
    SUM(score) AS total,
    AVG(score) AS average,
    MIN(score) AS minimum,
    MAX(score) AS maximum,
    COUNT(DISTINCT user_id) AS distinct_users
FROM ratings;

-- Results:
-- count: 200
-- total: 569.3
-- average: 2.8465
-- minimum: 0.5
-- maximum: 5
-- distinct_users: 30

-- The statistic results do not show anything unusual, but does not indicate the distribution of the ratings.
-- It is also clear that there are 200 ratings, but only 30 distinct users, which means that some users
-- submitted multiple ratings.

-- 2. Write a query that calculates the event count and average metric for each producer.
-- Sort the results from the producer with the most events to the producer with the fewest.
-- Requirement: SELECT, COUNT, AVG, JOIN, GROUP BY, ORDER BY

SELECT m.movie_id, m.title, COUNT(*) AS rating_count, AVG(r.score) AS avg_score
FROM movies m
JOIN ratings r
ON m.movie_id = r.movie_id
GROUP BY m.movie_id, m.title
ORDER BY rating_count DESC;

-- The resulting table shows that the most active movie is Title_06 (21 ratings), and the least active
-- is Title_04 (6 ratings). For the performance/rating, Title_05 had the highest average score (3.511) and
-- Title_11 had the lowest average score (2.09375). It also shows that a high rating count does
-- not necessarily mean the average score performance will also be high.


-- 3. Which producers have enough volume for their rate to mean anything?
-- Requirement: SELECT, COUNT, AVG, JOIN, GROUP BY, HAVING, ORDER BY

SELECT m.movie_id, m.title, COUNT(*) AS rating_count, AVG(r.score) AS avg_score
FROM movies m
JOIN ratings r ON m.movie_id = r.movie_id
GROUP BY m.movie_id, m.title
HAVING COUNT(*) >= 15
ORDER BY rating_count DESC;

-- I chose a minimum threshold of 15 because if there are too few ratings, the average score
-- may not be very accurate because it can be affected by individual reviewers. With a 
-- minimum threshold of 15, there are still 8 results in the table which can provide
-- a reasonable group for comparison. A lower threshold would include more movies, 
-- but it may not have enough ratings to compare. A higher threshold may make the
-- results more reliable, but some movies would be left out.



-- 4. Write a query that groups the data by two dimensions, including region, and
-- calculates the relevant summary statistics.

SELECT m.movie_id, m.title, r.device_country, COUNT(*) AS rating_count, AVG(r.score) AS avg_score, MIN(r.score) AS minimum_score, MAX(r.score) AS maximum_score
FROM movies m
JOIN ratings r ON m.movie_id = r.movie_id
GROUP BY m.movie_id, m.title, r.device_country
ORDER BY device_country, avg_score DESC;

-- The two dimensions chosen was movies and device country/region. The result shows that
-- Title_04 and Title_12 had the highest performance, indicated by average score, in India,
-- but only had 1 rating. It also shows that some movies can have a different perception in
-- another country, for example, Title_12 in India had an average score of 5.0 with 1 rating,
-- an average score of 3.275 in Brazil with 4 ratings, and an average score of 2.96 in Vietnam
-- with 5 ratings. The performance needs to be considered by using a combination of rating count,
-- average score, and min/max scores, especially since most have a very small number of ratings.