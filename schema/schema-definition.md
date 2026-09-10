## Schema Definition

Users: 
- user_id: primary key, integer
- username: varchar(100)
- gender: varchar(20)

Movies:
- movie_id: primary key, integer
- title: varchar(100) 
- is_active: boolean
- duration_minutes: integer
- year_released: integer
- summary: text 

Ratings :
- rating_id: primary key, integer
- user_id: foreign key
- movies_id: foreign key
- score: integer 
- datetime_reviewed: timestamp

Genres:
- genre_id: primary key, integer
- genre_name: varchar(100)

Movies_genres:
- movie_id: primary key, foreign key
- genre_id: primary key, foreign key
