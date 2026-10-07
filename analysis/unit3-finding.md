## Unit 3: The memo

<b>State what the dashboard reported, what the data actually shows, where the error came from, and what should happen to the frozen payout. Write for a reader who does not write SQL: no queries, and no jargon they would not already know.</b>

The dashboard reported incorrect results due to mistakes in the SQL query. The withdrawn reason contains values like "Spam detected", "Duplicate rating", "User request", "Policy violation", or no value. Some rows have no withdrawal reason recorded. This means that when looking for ratings not marked as "Spam detected", it might seem this would return any rows that do not have "Spam detected", but it does not take into consideration the rows with no reason, causing it to return a wrong result. For example, the query that had the negation of "Spam detected" returned 22 rows, but the correct result is actually 188. This means that 188 ratings were not marked as "Spam detected". 

Due to the error, the dashboard incorrectly reported that 22 ratings were not spam. This number failed to consider ratings that had no withdrawn reason recorded. The reviewer payout should be frozen until this error is fixed, since reviewers should only get paid for valid ratings.
