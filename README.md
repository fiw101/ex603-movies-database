# Movie Rating Database
Theme: Movies

Summary: The purpose of this database is to organize movie and user rating information for analysis purposes. 

The database stores movies, users, ratings, and genres information. Users submit ratings for movies. Each rating records the user, movie, and score data. Movies connect to genres through the junction table movie_genre so that each movie can be associated with multiple genres and each genre can have many movies associated with it. This allows the database to keep the rating and movie data organized. 

The database should be able to answer questions such as which movie has the highest average rating score, how many ratings each movie receives, and how many movies are released each year. This database can also be used to determine whether there is a relationship between a user’s gender and the genres of the movies they rated, and whether longer movies tend to receive higher or lower scores. These questions help analyze movie preferences and understand patterns in movie ratings. 

### Entity Relationship Diagram (ERD)
![ERD](schema/erd.png)

### Schema

Tables
- users: registered users that are rating the movies
- movies: includes movie information, such as title, release year, and duration in minutes
- genres: includes categories for movie genres, such as comedy, action, etc
- ratings: includes rating information users submit for any movies
- movies_genres: junction table mapping movies to genres (M:N)

Design Decisions
- Created a junction table called movies_genres with a composite primary key to prevent duplicate genres tied to a movie
- Implemented CHECK constraints on attributes like year released, rating score, and gender to ensure only valid data is allowed into the database
- Chose ON DELETE actions such as SET NULL and RESTRICT that best fit the needs and purpose of this database to ensure any essential data that may be used for analysis are not deleted
- Chose the types that fit each attribute such as NUMERIC(3,2) for rating score and varchar(n) with an n that makes sense 
- Added a derived attribute in Movies called display_title which combines the title and year released
- Added a recursive foreign key in movies by adding a foreign key called related_movie_id. This can be used to indicate whether the movie has any related movies, e.g. a prequel or sequel.
- Included a weak entity in Ratings which uses ON DELETE CASCADE and a composite primary key of user_id and movie_id. This also means that a user can only make one rating for a movie.
