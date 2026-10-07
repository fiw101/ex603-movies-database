-- 3.3: Find which actors (users/top reviews) were involved in
-- disputed events (spam withdrawal and reviewer payouts)

-- 1: subquery using IN or NOT IN
-- Returns 10 users
-- Requirement: SELECT, WHERE, IN
SELECT user_id, user_name
FROM users
WHERE user_id IN (
    SELECT user_id
    FROM ratings
    WHERE withdrawn_reason = 'Spam detected'
);

-- 2: Common Table Expression using WITH
-- Returns 10 users
-- Requirement: SELECT, DISTINCT, WHERE, WITH, JOIN, ON
WITH spam_review_users AS (
    SELECT DISTINCT user_id
    FROM ratings
    WHERE withdrawn_reason = 'Spam detected'
)
SELECT u.user_id, u.user_name
FROM users u
JOIN spam_review_users s ON u.user_id = s.user_id;

-- 3: A different subquery form using EXISTS
-- Returns 10 users
-- Requirement: SELECT, WHERE, EXISTS
SELECT user_id, user_name
FROM users u
WHERE EXISTS (
    SELECT 1
    FROM ratings r
    WHERE r.user_id = u.user_id AND r.withdrawn_reason = 'Spam detected'
);

-- 4. Show all three queries return identical result sets
-- Expected: no rows if the result sets are identical
-- Requirement: SELECT, EXCEPT, UNION ALL, WITH
-- Compare query 1 vs query 2
(
    SELECT user_id, user_name
    FROM users
    WHERE user_id IN (
        SELECT user_id
        FROM ratings
        WHERE withdrawn_reason = 'Spam detected'
    )
)
EXCEPT
(
    WITH spam_review_users AS (
        SELECT DISTINCT user_id
        FROM ratings
        WHERE withdrawn_reason = 'Spam detected'
    )
    SELECT u.user_id, u.user_name
    FROM users u
    JOIN spam_review_users s ON u.user_id = s.user_id
)

UNION ALL

-- Compare query 2 vs query 3
(
    WITH spam_review_users AS (
        SELECT DISTINCT user_id
        FROM ratings
        WHERE withdrawn_reason = 'Spam detected'
    )
    SELECT u.user_id, u.user_name
    FROM users u
    JOIN spam_review_users s ON u.user_id = s.user_id
)
EXCEPT
(
    SELECT user_id, user_name
    FROM users u
    WHERE EXISTS (
        SELECT 1
        FROM ratings r
        WHERE r.user_id = u.user_id AND r.withdrawn_reason = 'Spam detected'
    )
);


-- 5: One input condition where the 3 would not have the same results is if a user has multiple
-- ratings marked as 'Spam detected', meaning that there are duplicates. Using IN (Question 1)
-- and EXISTS (Question 3) automatically do not return duplicate rows. However, a CTE using WITH
-- uses JOIN to combine the CTE table with the users table, which means that without DISTINCT,
-- there would be duplicate rows in the CTE result.
