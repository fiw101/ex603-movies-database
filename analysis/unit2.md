### Constraint table

| Foreign key | ON DELETE choice | Reason |
| --- | --- | --- |
| fk_rating_user | CASCADE | When a user deletes their account, the user's ratings do not need to be kept. |
| fk_rating_movie | RESTRICT | A movie cannot be deleted, and the is_active flag on movies should be used instead. |
| fk_movie_genre_movie | RESTRICT | A movie cannot be deleted, and the is_active flag on movies should be used instead. |
| fk_movie_genre_genre | RESTRICT | Since genres is a categorical table and expects some foundational genre names, genres cannot be deleted to prevent any accidental deletions that could affect the genres assigned for multiple movies. |
| fk_movie_referrer | SET NULL | When a related movie is deleted, the referred movie should be set to null rather than deleting the movie. |

<b>For each ON DELETE choice, describe the real event it governs. What actually happens on your platform when a producer is removed? Name who or what is affected by the choice you made, and what would go wrong under the alternative.</b>

- ON DELETE CASCADE was chosen for fk_rating_user because if an account is deleted, the platform will remove the user’s account and everything related to the user, including the ratings. Because the project instructions required a weak entity, SET NULL cannot be used as that will make user_id on Ratings NULL and a composite primary key cannot have a NULL value. RESTRICT cannot be used as well in this situation since users that rated a movie should be able to delete their account if they want.

- fk_rating_movie is for if a movie with ratings is deleted. The system is designed to not let a movie (producer role) be deleted, so ON DELETE RESTRICT is used. Instead, they can use the is_active flag. This helps with database integrity because otherwise, if CASCADE is used, valuable movie and rating information would be deleted. SET NULL is also not the right choice because movie_id would be null, while the rating information is kept, which would mean the ratings that don’t have a movie connected with it now serve no purpose.

- fk_movie_genre_movie is for if a movie with data in the junction table movies_genres is deleted. ON DELETE RESTRICT is used because a movie (producer role) should use the is_active flag rather than delete it. CASCADE would mean that any data in the junction table would be removed when a movie is deleted, but with an is_active flag, this helps to prevent accidental deletions.

- fk_movie_genre_genre is for if a genre is deleted. CASCADE is not an option because it would mean if a genre is deleted, it would impact any movies that have that genre assigned. Therefore, the system uses ON DELETE RESTRICT to help prevent any accidental deletions to the genres.

- fk_movie_referrer is for when a related movie, like a prequel or sequel, is deleted. ON DELETE SET NULL is used because we want the movie to be kept in the database, with only the related movie set to null. CASCADE would not be right in this situation because it would mean when a related movie is removed, the current movie is also deleted. RESTRICT is also not the right choice because it would make it difficult for anyone maintaining the database to remove a related movie.

### CHECK narrative
- chk_user_gender_valid is used to ensure the gender entered in can only be 3 possible values: Male, Female, and Other to prevent any typos or unexpected values. This issue could arise if the frontend form has any issues that would somehow allow bad data to get in or if the data is pulled in from an API. 
- chk_movie_duration_positive is used to ensure the value entered for a movie duration is a positive number greater than zero since it does not make sense for a movie to be negative minutes. This invalid state could arise from a typo or wrong data provided through an API.
- chk_rating_score is used to verify a user rating is between 1.00 to 5.00. Any other numbers, for example, 6.00, are considered invalid rating scores, so the system needs to add this constraint to enforce this. This invalid rating score could arise from a user finding a way to add bad data or if it was pulled from an API that may use a different rating scale, which would negatively impact the value on the analyzing result.
- chk_movie_year_released is used to restrict the input for movie year to between 1800 and 2200. This constraint helps with any typos in the data on the year field. For example, a negative year like -50 or a missing digit like 202 should be considered invalid.

### Unit 2 Updates
1. Changed type of Ratings -> score to NUMERIC(3,2) rather than INTEGER to allow rating scores with decimals, e.g. 4.5
2. Added a derived attribute in Movies called display_title which combines the title and year released
3. Changed the Ratings table to have a composite primary key of user_id and movie_id, and removed rating_id primary key. This also makes it a weak entity. Since a composite primary key cannot have a NULL value, I also changed ON DELETE SET NULL to ON DELETE CASCADE for fk_rating_user.
4. Added a recursive foreign key in movies by adding a foreign key called related_movie_id. This can be used to indicate whether the movie has any related movies, e.g. a prequel or sequel.