/*
  Lab 02: MariaDB Tutorial
  CSC 362 Database Systems
*/

/* Create the database (dropping the previous version if necessary */
DROP DATABASE IF EXISTS bookstore;

CREATE DATABASE bookstore;

USE bookstore;


/* Create the two tables */
CREATE TABLE books (
    PRIMARY KEY (isbn),
    isbn         CHAR(20),
    title        VARCHAR(50),
    author_id    INT,
    publisher_id INT,
    year_pub     CHAR(4),
    description  TEXT
);

CREATE TABLE authors (
    PRIMARY KEY (author_id),
    author_id   INT AUTO_INCREMENT,
    name_last   VARCHAR(50),
    name_first  VARCHAR(50),
    country     VARCHAR(50)
);

/* Populate the tables with sample data */
INSERT INTO authors (name_last, name_first, country)
VALUES ('Kafka', 'Franz', 'Czech Republic');

INSERT INTO books (title, author_id, isbn, year_pub)
VALUES ('The Castle',        '1', '0805211063', '1998'),
       ('The Trial',         '1', '0805210407', '1995'),
       ('The Metamorphosis', '1', '0553213695', '1995'),
       ('America',           '1', '0805210644', '1995');

/* Use SELECT to display some "reports" from the 3 tables. */
SELECT title FROM books;

SELECT title, name_last 
  FROM books 
  JOIN authors USING (author_id);

SELECT title AS 'Kafka Books'
  FROM books 
  JOIN authors USING (author_id)
 WHERE name_last = 'Kafka';



/* Create the database (dropping the previous version if necessary */
DROP DATABASE IF EXISTS school;

CREATE DATABASE school;

USE school;

/* Create table instructor*/

CREATE TABLE instructors(
  PRIMARY KEY (instructor_id),
  instructor_id INT AUTO_INCREMENT, 
  inst_first_name VARCHAR(20), 
  inst_last_name VARCHAR(20),
  campus_phone VARCHAR(20)
);

/* Populating the information in the instructor table */
INSERT INTO instructors(inst_first_name, inst_last_name, campus_phone)
VALUES ('Kira', 'Bently', '363-9948'),
       ('Timothy', 'Ennis', '527-4992'),
       ('Shannon', 'Black', '322-5992'),
       ('Estela', 'Rosales', '322-6992');


/* Using Select to display from the table */

SELECT * FROM instructors;


/* End of file lab02a.sql */
