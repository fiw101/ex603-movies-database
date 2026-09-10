## Schema Constraints

Users: 
- user_id: primary key, unique, not null
    - The user_id primary key will be used to identify each user.
- username: unique, not null
    - Every user account should have its unique username to easily identify the user. 
- gender: not null, must be either Male, Female, or Other
    - The gender field is constrained to either be set as male, female, or other, since we do not want users typing in invalid values, which would make it difficult to analyze the data.

Movies:
- movie_id: unique, not null
    - The movie_id primary key will be used to identify each movie.
- title: not null
    - For data integrity purposes, the title must be filled in when a movie is created.
- is_active: not null
    - The is_active flag is a boolean to identify whether the movie is listed or not.
- duration_minutes: not null, greater than 0
    - The duration added should be in minutes, so the value must be greater than 0. 
- year_released: not null
    - The year released should be added when a movie is created. Complete movie information is wanted so this field cannot be null.
- summary: 
    - If the movie is newly released, there may not be a summary ready yet, so there is no not null constraint set on this field. 

Ratings :
- rating_id: primary key, not null
    - This is the primary key for the ratings table to ensure all rating entries are unique.
- user_id: foreign key, ON DELETE SET NULL
    - This is used to link a rating to a user. ON DELETE SET NULL was chosen since when a user deletes their account, we will want to keep their rating for analyzing purposes. There is also a unique constraint for composite key user_id and movies_id.
- movie_id: foreign key, not null, ON DELETE RESTRICT
    - This is used to link a rating to a movie. Restrict was used to prevent deleting a movie. If that does need to happen, the movies table has a is_active flag. There is also a unique constraint for composite key user_id and movies_id.
- score: not null
    - Each rating must have a score between 1 to 5.
- datetime_reviewed: default: now, not null
    - The current timestamp when the user fills out the rating is automatically assigned to this datetime_reviewed attribute.

Genres:
- genre_id: primary key, not null
    - This is the primary key for the genres table to ensure all genre entries are unique.
- genre_name: varchar(100), not null, unique
    - Each genre_name added to this table must be unique, since it does not make sense to have duplicate rows for the same genre, e.g. action.

Movies_genres:
- movie_id: foreign key, not null, ON DELETE RESTRICT
    - A movie cannot be deleted, and the is_active flag on movies should be used instead.
- genre_id: foreign key, not null, ON DELETE RESTRICT
    - Since genres is a categorical table and expects some foundational genre names like comedy, action, etc, genres should not be able to be deleted. This helps to prevent any accidental deletions that could affect the genres assigned for multiple movies.
- Composite primary key: movie_id, genre_id
    - Both movie_id and genre_id are used to form a composite primary key that can be used to uniquely identify them together. This prevents any duplicates because a movie should not have the same genre included multiple times.
