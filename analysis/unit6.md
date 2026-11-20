## Task 6.1: Compute across a window without collapsing

Write up

1. <b>Write a question that needs each row shown next to its group’s average. Explain why the group average alone (GROUP BY) cannot answer it.</b>

How does each individual movie rating compare with the average rating for that movie?

The AVG() OVER (PARTITION BY movie_id) window function can be used to display every individual movie rating and average rating for that movie. On the other hand, the GROUP BY query only shows the average rating for each movie, not individual rating. Therefore, the result from the window function returns 200 rows and group by only returns 13 rows. Using a window function can provide more details like comparing each individual movie rating to see if the rating is higher or lower than the movie's average rating. 

2. <b>Ranking is never neutral: someone is being ordered, and tie handling decides who counts as equal. Name a platform feature that would use your ranking, and explain which of the three functions it should use and why.</b>

A platform feature that would use rankings is movies rating leaderboard. I would choose RANK because if there are ties, there will be gaps in the ranking positions. For example, when 2 movies are tied for first place, these 2 movies will both be listed as first place and the third movie will be ranked as third place.

## Task 6.2

1. <b>What would a large delta tell someone about your platform, and what should they do about it?</b>

A large delta shows a big change between the current and previous rating, with a positive delta indicating the current rating is much higher and a negative delta indicating the current rating is lower. If there is a large delta, the team should investigate the results and see if there are any issues with the movie. 

2. <b>Why does a running total answer a question that a plain SUM cannot?</b>

A running total helps to show how the total ratings increase over time, which can help us to find out the platform's performance during different time periods. However, SUM cannot show this because it only shows one total for all the ratings.

3. <b>Why did you pick your moving-average window size? A different size tells a different story.</b>

I picked 7 row moving average window sizes which include the current rating and the previous 6 ratings which shows recent rating trends more clearly. I believe this is a reasonable window size to observe instead of focusing too much on individual ratings. The smaller size can show changes faster while a big size shows a smoother trend.

4. <b>What does a gap mean in your platform: a data quality problem, a real stop in activity, or a side effect of how events were recorded? Each needs a different response. Say which one yours is and how you know.</b>

Based on the results, a gap of more than 30 days in my platform shows a real stop in activity because there were no recorded ratings for that movie during that time. The results show there were gaps of over 1000 days with no activity. However, the cause cannot be determined from the available data, so the team will need to investigate the reason behind it. 


## Task 6.3
1. <b>Name the feature in your platform that top-N would power. Explain why three is the right number, rather than one or ten.</b>

The feature for top-N would be displaying the top 3 highest ratings for each movie. One rating is not enough to compare, and ten ratings would be too much data, so three feels like the right number to not display too much unnecessary data for the user. 

2. <b>What would a large month-over-month change mean in your domain, and what should someone do about it? A number nobody acts on is not a metric.</b>

A large month-over-month change means there is a big change in the failure rate compared with the previous month. A positive change indicates that the failure rate increased. On the other hand, a negative change indicates a decrease. By using this information, the team can find out if there are any issues and look for solutions.


## Reflection (150–250 words)
<b>Write this at the end of /analysis/unit6.md. Window functions keep rows; aggregates collapse them. Describe a reporting question in your theme that is easy with a window function but awkward or impossible with GROUP BY alone. Explain why.</b>

Window functions keep original individual rows and also add other information, but group by aggregation only shows the summary of the data. One question from the report where it is better to use a window function is: How does each individual movie rating compare with the average rating for that movie?

To show every individual movie rating together with the average rating for that movie, I would use the AVG() OVER (PARTITION BY movie_id) window function. This makes it easy to observe each movie's individual rating and find out if they have higher or lower ratings compared with the movie's average rating. It also helps to identify records that are different from the average rating. However, with GROUP BY, it calculates and shows the average rating for each movie, without displaying individual records. This approach would be better for a summary report. My results from the window query returns 200 rows but GROUP BY only returns 13 rows, since there are a total of 13 movies. Both window and GROUP BY function are useful and serve different purposes.
