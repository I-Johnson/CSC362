/* 
    Lab 03: Tables & Fields in SQL
    CSC 362 Database Systems
    Johnson Subedi
*/

/* Creating the database (dropping the previous versions) */

DROP DATABASE IF EXISTS movie_ratings;

CREATE DATABASE movie_ratings;

USE movie_ratings;


/* Create the three tables */ 

CREATE TABLE Movies (
    PRIMARY KEY (MovieID),
    MovieID INT AUTO_INCREMENT,
    MovieTitle VARCHAR(64), 
    ReleaseDate DATE, 
    Genre VARCHAR(64)
);

/* Consumers Table Creation */ 

CREATE TABLE Consumers(
    PRIMARY KEY (ConsumerID),
    ConsumerID INT AUTO_INCREMENT,
    FirstName VARCHAR(64), 
    LastName VARCHAR(64), 
    ConsumerAddress VARCHAR(64), 
    City VARCHAR(64), 
    ConsumerState VARCHAR(64), 
    ZIPCODE INT
);

/* Rating Table Creating */ 

CREATE TABLE Ratings(
    MovieID INT, 
    ConsumerID INT, 
    WhenRated DATETIME, 
    NumberStars INT, 
    PRIMARY KEY (MovieID, ConsumerID), 
    FOREIGN KEY (MovieID) REFERENCES Movies(MovieID), 
    FOREIGN KEY (ConsumerID) REFERENCES Consumers(ConsumerID)
);

/* Populating the information in the movie table */

/* Populating Movies Table */
INSERT INTO Movies(MovieTitle, ReleaseDate, Genre)
VALUES ('The Hunt for Red October', '1990-03-02', 'Acton, Adventure, Thriller'), 
       ('Lady Bird', '2017-12-01', 'Comedy, Drama'), 
       ('Inception', '2010-08-16', 'Action, Adventure, Science Fiction'),
       ('Monty Python and the Holy Grail', '1975-04-03', 'Comedy');

/* Populating Consumers table */
INSERT INTO Consumers (FirstName, LastName, ConsumerAddress, City, ConsumerState, ZIPCODE)
VALUES
    ('Toru', 'Okada', '800 Glenridge Ave', 'Hobart', 'IN', 46343),
    ('Kumiko', 'Okada', '864 NW Bohemia St', 'Vincentown', 'NJ', 08088),
    ('Noboru', 'Wataya', '342 Joy Ridge St', 'Hermitage', 'TN', 37076),
    ('May', 'Kasahara', '5 Kent Rd', 'East Haven', 'CT', 06512);


/* Populating Ratings Table */
-- Insert sample data into the Ratings table
INSERT INTO Ratings (MovieID, ConsumerID, WhenRated, NumberStars)
VALUES
    (1, 1, '2010-09-02 10:54:19', 4),
    (1, 3, '2012-08-05 15:00:01', 3),
    (1, 4, '2016-10-02 23:58:12', 1),
    (2, 3, '2017-03-27 00:12:48', 2),
    (2, 4, '2018-08-02 00:54:42', 4);


        /* Generate a report */
    SELECT FirstName, LastName, MovieTitle, NumberStars
      FROM Movies
           NATURAL JOIN Ratings
           NATURAL JOIN Consumers;


/* Database above has multiple genres in a single 'Genres' column within the 'Movies' 
table. This approach makes data querying and maintenance complex, limiting precise searches
and data consistency. To improve this, we use validation table for movies and genres. */


DROP DATABASE IF EXISTS movie_ratings;

CREATE DATABASE movie_ratings;

USE movie_ratings;


/* Create the three tables */ 

CREATE TABLE Movies (
    PRIMARY KEY (MovieID),
    MovieID INT AUTO_INCREMENT,
    MovieTitle VARCHAR(64), 
    ReleaseDate DATE
    -- Genre VARCHAR(64)
);

/* Consumers Table Creation */ 

CREATE TABLE Consumers(
    PRIMARY KEY (ConsumerID),
    ConsumerID INT AUTO_INCREMENT,
    FirstName VARCHAR(64), 
    LastName VARCHAR(64), 
    ConsumerAddress VARCHAR(64), 
    City VARCHAR(64), 
    ConsumerState VARCHAR(64), 
    ZIPCODE INT
);

/* Rating Table Creating */ 

CREATE TABLE Ratings(
    MovieID     INT, 
    ConsumerID  INT, 
    WhenRated   DATETIME, -- Line up the data types like this. -- WB
    NumberStars INT, 
    PRIMARY KEY (MovieID, ConsumerID), 
    FOREIGN KEY (MovieID) REFERENCES Movies(MovieID), 
    FOREIGN KEY (ConsumerID) REFERENCES Consumers(ConsumerID)
);

/* Genre Table Creation */ -- Validation Table

CREATE TABLE Genre(
    PRIMARY KEY (GenreID),
    GenreID INT AUTO_INCREMENT,
    GenreName VARCHAR(64)
);

/* Table to connect Genre and Movie ID */
CREATE TABLE MovieGenres(
    MovieID INT, 
    GenreID INT, 
    PRIMARY KEY (MovieID, GenreID),
    FOREIGN KEY (MovieID) REFERENCES Movies(MovieID),
    FOREIGN KEY (GenreID) REFERENCES Genre(GenreID)
);

/* Populating the information in the movie table */

/* Populating Movies Table */
INSERT INTO Movies(MovieTitle, ReleaseDate)
VALUES ('The Hunt for Red October', '1990-03-02'), 
       ('Lady Bird', '2017-12-01'), 
       ('Inception', '2010-08-16'),
       ('Monty Python and the Holy Grail', '1975-04-03');

/* Populating Consumers table */
INSERT INTO Consumers (FirstName, LastName, ConsumerAddress, City, ConsumerState, ZIPCODE)
VALUES
    ('Toru', 'Okada', '800 Glenridge Ave', 'Hobart', 'IN', 46343),
    ('Kumiko', 'Okada', '864 NW Bohemia St', 'Vincentown', 'NJ', 08088),
    ('Noboru', 'Wataya', '342 Joy Ridge St', 'Hermitage', 'TN', 37076),
    ('May', 'Kasahara', '5 Kent Rd', 'East Haven', 'CT', 06512);


/* Populating Ratings Table */
-- Insert sample data into the Ratings table
INSERT INTO Ratings (MovieID, ConsumerID, WhenRated, NumberStars)
VALUES
    (1, 1, '2010-09-02 10:54:19', 4),
    (1, 3, '2012-08-05 15:00:01', 3),
    (1, 4, '2016-10-02 23:58:12', 1),
    (2, 3, '2017-03-27 00:12:48', 2),
    (2, 4, '2018-08-02 00:54:42', 4);

/* Populating Genre Table */
INSERT INTO Genre(GenreName)
VALUES
    ('Action'),
    ('Adventure'),
    ('Thriller'),
    ('Comedy'),
    ('Drama'),
    ('Science Fiction');


/* Populating MovieGenre Table */
INSERT INTO MovieGenres(MovieID, GenreID)
VALUES 
    (1, 1),
    (1, 2),
    (1, 3),
    (2, 4),
    (2, 5),
    (3, 1),
    (3, 2),
    (3, 6),
    (4, 4);

        /* Generate a report */
SELECT FirstName, LastName, MovieTitle, NumberStars
FROM Movies
    NATURAL JOIN Ratings
    NATURAL JOIN Consumers;
    
/* Generate a report */

SELECT FirstName, LastName, MovieTitle, NumberStars, GenreName
FROM Movies
    NATURAL JOIN Ratings
    NATURAL JOIN Consumers
    NATURAL JOIN Genre
    NATURAL JOIN MovieGenres;
