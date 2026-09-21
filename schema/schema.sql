-- =================================================================
-- EX 603 Assignment 2 — schema.sql
-- Theme: Movies
-- Author: Fidella Wu
-- Target: PostgreSQL 14+
-- =================================================================
-- Reset. Reverse creation order, so no dependency blocks a drop.
DROP TABLE IF EXISTS movies_genres CASCADE;
DROP TABLE IF EXISTS genres CASCADE;
DROP TABLE IF EXISTS ratings CASCADE;
DROP TABLE IF EXISTS movies CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- ----------------------------------------------------------------
-- 1. users — first, because it references nothing.
-- ----------------------------------------------------------------
CREATE TABLE users (
    user_id INTEGER GENERATED ALWAYS AS IDENTITY,
    username VARCHAR(100) NOT NULL,
    gender VARCHAR(100) NOT NULL,
    CONSTRAINT pk_user PRIMARY KEY (user_id),
    CONSTRAINT chk_user_gender_valid
    CHECK (gender IN ('Male', 'Female', 'Other'))
);

-- ----------------------------------------------------------------
-- 2. movies — it references nothing.
-- ----------------------------------------------------------------
CREATE TABLE movies (
    movie_id INTEGER GENERATED ALWAYS AS IDENTITY,
    title VARCHAR(255) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    duration_minutes INTEGER NOT NULL,
    year_released INTEGER NOT NULL,
    summary TEXT,
    display_title VARCHAR(255) NOT NULL GENERATED ALWAYS AS (title || ' (' || year_released || ')') STORED,
    related_movie_id INTEGER,
    CONSTRAINT pk_movie PRIMARY KEY (movie_id),
    CONSTRAINT fk_movie_referrer
    FOREIGN KEY (related_movie_id) REFERENCES movies (movie_id)
    ON DELETE SET NULL,
    CONSTRAINT chk_movie_duration_positive
    CHECK (duration_minutes > 0),
    CONSTRAINT chk_movie_year_released
    CHECK (year_released BETWEEN 1800 AND 2200)
);

-- ----------------------------------------------------------------
-- 3. ratings — it depends on users and movies, which was created above.
-- ----------------------------------------------------------------
CREATE TABLE ratings (
    user_id INTEGER NOT NULL,
    movie_id INTEGER NOT NULL,
    score NUMERIC(3,2) NOT NULL,
    datetime_reviewed TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_rating PRIMARY KEY (user_id, movie_id),
    CONSTRAINT fk_rating_user
    FOREIGN KEY (user_id) REFERENCES users (user_id)
    ON DELETE CASCADE,
    CONSTRAINT fk_rating_movie
    FOREIGN KEY (movie_id) REFERENCES movies (movie_id)
    ON DELETE RESTRICT,
    CONSTRAINT chk_rating_score
    CHECK (score BETWEEN 1.00 AND 5.00)
);

-- ----------------------------------------------------------------
-- 4. genres — it references nothing.
-- ----------------------------------------------------------------
CREATE TABLE genres (
    genre_id INTEGER GENERATED ALWAYS AS IDENTITY,
    genre_name VARCHAR(100) NOT NULL,
    CONSTRAINT pk_genre PRIMARY KEY (genre_id),
    CONSTRAINT uq_genre_name UNIQUE (genre_name)
);

-- ----------------------------------------------------------------
-- 5. movies_genres — resolves the M:N between movies and genres.
-- The primary key is the pair of foreign keys, not a new id.
-- It depends on movies and genres, which was created above.
-- ----------------------------------------------------------------
CREATE TABLE movies_genres (
    movie_id INTEGER NOT NULL,
    genre_id INTEGER NOT NULL,
    CONSTRAINT pk_movie_genre PRIMARY KEY (movie_id, genre_id),
    CONSTRAINT fk_movie_genre_movie
    FOREIGN KEY (movie_id) REFERENCES movies (movie_id)
    ON DELETE RESTRICT,
    CONSTRAINT fk_movie_genre_genre
    FOREIGN KEY (genre_id) REFERENCES genres (genre_id)
    ON DELETE RESTRICT
);