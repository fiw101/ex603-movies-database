## Task 5.1 Write up

<b>1. What feature or report on your platform could use the three-table join from Question 1? What information would it display?</b>

A movie rating report could find the three table join useful. It would help to show the movie's title, the user who submitted the rating, and rating information like score and date time reviewed, all in one table.

<b>2. Why is the junction table important for answering Question 2? What would make this analysis more difficult without it?</b>

The junction table ```movies_genres``` is important because it connects movies and genres. It shows that there is a many to many relationship between movies and genres, where a movie can belong to multiple genres and a genre can be associated with multiple movies. Without this, it would be more difficult to find which genres are associated with which movies.


## Task 5.2 Write up
<b>1. Which producers were excluded by the inner join? Report their identifiers.</b>

The producers/movies excluded by the inner join were Title_14 with movie_id 14 and Title_15 with movie_id 15.

<b>2. What does it mean when a producer has no events? What are some possible explanations?</b>

When a movie has no ratings, this means no users have rated the movie. This could happen because the movie is not as popular or it is relatively new.

<b>3. How could a report based only on an inner join give leadership an incomplete picture of the platform?</b>

An inner join gives an incomplete picture of the platform because movies that have no ratings do not appear in the results. This kind of information is also important because leadership will find it useful to know which movies have not received any ratings.

<b>4. Why might leadership want to identify producers who have never been active?</b>

Identifying movies that have never been active is important because it means there could be something going on that isn't making it appealing for viewers. If there are no or few viewers, it means less engagement, which may lead to fewer ratings. Leadership may want to use this information to identify movies that may need to be promoted more.

<b>5. What action could leadership take based on these findings?</b>

Leadership should look into why Title_14 and Title_15 have not gotten any ratings yet. Then, they should try to promote the movie more to get more viewers, which will increase the chances for ratings.

## Task 5.3 Write up
<b>1. Give an example of when a Cartesian product could be useful on your platform, or explain why you would not need one.</b>

A Cartesian product could be useful on my platform to show all possible combinations of movies and genres. 

<b>2. Which join algorithms did PostgreSQL choose for your query?</b>

PostgreSQL used a Hash Join to join ratings and users, and a Nested Loop to join the results with movies. 

<b>3. What information in the execution plan helps explain those choices?</b>

The execution plan shows 200 rows in ratings and 100 rows in users. It uses the index movie_id to search for matching movies. 

<b>4. Why is it useful to understand the selected join algorithms?</b>

It is useful to understand the selected join algorithms because it helps us know how algorithms join tables together and how to make the query have better performance. 

<b>5. What changes to the data or database might make another join algorithm more appropriate?</b>

If the database becomes larger and more index added it may choose another type of join so the query can run more efficiently. 


## Reflection (150–250 words)

<b>In Task 5.3, you examined the execution plan for your three-table join. Reflect on the following question: What changes to your data or database schema might cause PostgreSQL to choose a different join algorithm?

Consider factors such as table size, indexes, and the number of matching records. Explain how these changes could influence query performance.</b>

The three common join algorithms that PostgreSQL can choose from are Nested Loop, Hash Join, and Merge Join, and each of them works best under different situations. If the table sizes are large and unsorted, and the join checks for equal values, then PostgreSQL may use hash join to match records because it can be more efficient. If the outer table is small and there is an index on the inner table, it is more useful for PostgreSQL to choose a nested loop because the index helps to find matching records faster. However, it can also become less efficient as the number of matching records increases. Merge join is suitable for large tables, where both tables are sorted or have indexes on the join columns.

This can be seen in Task 5.3 execution plan, where both hash join and nested loop were used. Hash join was used to match ratings and users quickly using user id. Then, a nested loop used the primary key index movie_id to quickly find matching movies.

Understanding the different types of join algorithms helps us know how PostgreSQL connects tables and manages query performance. Based on the data size and availability of the index, PostgreSQL chooses the best suitable algorithm to improve query performance. Examining the execution plan using EXPLAIN helps to find out why PostgreSQL selects that join algorithm. This also helps to improve query speed when the database changes or grows. 
