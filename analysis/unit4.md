## Task 4.1
Name the person who would act on the per-producer breakdown, and say what the aggregate hides — an average conceals its distribution, a count conceals who is counted. What would you need to see next?

The person who would act on the per-producer breakdown is a movie analyst, since they are responsible for evaluating how well a movie is rated. However, an average score is not able to show the breakdown of scores that was given for each movie because a movie can receive both high and low ratings that balanced out to have a similar average ratings. A rating count also does not show how many different reviewers submitted because some reviewers can submit multiple times. Next, I think examining the distribution of the scores and number of distinct users who rated the movies would be useful. 

## Task 4.2
<b>For Part A, state the two questions your conditional aggregation answers side by side.</b>

1. How many rating events were there for each movie?
2. How many ratings had a failure state of spam detected?

<b>For Part B, name the reader who needs subtotals rather than detail rows, and say what decision the grand total supports that the group rows do not.</b>

The reader who needs subtotals rather than detail rows would be a regional manager. They are able to use the group rows to see how each region performs, while the grand total can help to determine whether the spam reviews are a global or regional issue.

<b>For Part C, state the question the pipeline answers.</b>

The pipeline can be used to answer the question of: With performance metrics like an average number of ratings and average number of failures, what is the baseline of how movies with at least 15 ratings should be performing?

## Reflection (150–250 words)
<b>Conditional aggregation computes several answers in one pass over the data. Contrast that with running two separate filtered queries. At a million rows, why does the difference matter?</b>

Conditional aggregation means using CASE WHEN to evaluate multiple aggregate conditions, like calculating the sum, average, minimum, or maximum, in one query at once with only one table scan. The other option is to run two separate filtered queries, which may require the database to scan the table multiple times.

For a large database of one million rows, this can make a huge difference in performance. When performing repeated scans, it can increase CPU usage and query processing time. Another benefit of conditional aggregation is that it is more efficient because it can handle multiple conditions in a single query and return all the calculated results at the same time. This makes the results easier to compare and reduces the need to run separate queries. Therefore, conditional aggregation is often the preferred approach whenever possible, especially since the performance gap increases as the dataset scales. However, the actual performance improvement depends on how the database runs the query. 