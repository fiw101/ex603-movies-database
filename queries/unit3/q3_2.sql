-- Part A: The rows that vanished

-- 1. withdrawn_reason in ratings is a nullable column


-- 2. withdrawn_reason contains values like "Spam detected", "Duplicate rating", "User request",
-- or "Policy violation". WHERE withdrawn_reason != 'Spam detected' returns 22
-- Requirement: SELECT, WHERE
SELECT COUNT(*) AS not_spam_count
FROM ratings
WHERE withdrawn_reason != 'Spam detected';


-- 3. WHERE withdrawn_reason IS NULL returns 166.
-- Requirement: SELECT, WHERE, IS NULL
SELECT COUNT(*) AS null_withdrawn_reason_count
FROM ratings
WHERE withdrawn_reason IS NULL;

-- Total rating count is 200. The first query returns 22 and the second query
-- returns 166, so 22 + 166 = 188, not 200. NULLs are excluded from the first query
-- Requirement: SELECT, COUNT
SELECT COUNT(*) AS total_ratings
FROM ratings;


-- 4. I used COALESCE to convert the NULL withdrawn_reasons to an empty string (''),
-- which can now be used to compare to 'Spam detected'. This query now returns the correct
-- result of 188.
-- Requirement: SELECT, WHERE, COALESCE
SELECT COUNT(*) AS repaired_not_spam_count
FROM ratings
WHERE COALESCE(withdrawn_reason, '') != 'Spam detected';


-- Part B: The alias that didn't exist yet

-- 1. The query attempts to convert hours to minutes, but returns an error message of
-- "ERROR: column 'watch_hours' does not exist"
-- Requirement: SELECT, WHERE, AS
SELECT watch_minutes / 60 AS watch_hours
FROM ratings
WHERE watch_hours < 0.5;


-- 2. Two correct rewrites to convert watch hours to minutes
-- Repeat expression in WHERE
-- Requirement: SELECT, WHERE, AS
SELECT watch_minutes / 60 AS watch_hours
FROM ratings
WHERE watch_minutes / 60 > 0.45;


-- Use CTE
-- Requirement: SELECT, WHERE, AS, WITH
WITH watch_hours_table AS (
    SELECT watch_minutes / 60 AS watch_hours
    FROM ratings
)
SELECT watch_hours
FROM watch_hours_table
WHERE watch_hours > 0.45;