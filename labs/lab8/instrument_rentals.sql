DROP DATABASE IF EXISTS instrument_rentals;
CREATE DATABASE instrument_rentals;
USE instrument_rentals;

CREATE TABLE students (
    PRIMARY KEY (student_id),
    student_id      INT AUTO_INCREMENT,
    student_name    VARCHAR(64)
);

CREATE TABLE instrument_types (
    PRIMARY KEY (instrument_type),
    instrument_type VARCHAR(32)
);

CREATE TABLE instruments (
    PRIMARY KEY (instrument_id),
    instrument_id      INT AUTO_INCREMENT,
    instrument_type    VARCHAR(32),
    FOREIGN KEY (instrument_type) REFERENCES instrument_types (instrument_type)
);

-- This was what I wanted, but is not legal in MariaDB.
CREATE TABLE student_instruments (
    PRIMARY KEY (student_id, instrument_id),
    student_id      INT NOT NULL, -- NOT NULL is probably not necessary
    instrument_id   INT NOT NULL UNIQUE,
    checkout_date   DATE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    check_in_date   DATE DEFAULT NULL,
    FOREIGN KEY (student_id) REFERENCES students (student_id),
    FOREIGN KEY (instrument_id) REFERENCES instruments (instrument_id)
);

-- Define a view of only the currently checked out instruments.
CREATE VIEW open_rentals AS
SELECT * 
  FROM student_instruments
       WHERE (check_in_date is NULL);

-- Enroll some students.
INSERT INTO students (student_name)
VALUES ('Neo'),
       ('Morpheous'),
       ('Trinity'),
       ('Cypher'),
       ('Tank');

INSERT INTO instrument_types (instrument_type)
VALUES ('Guitar'),
       ('Trumpet'),
       ('Flute'),
       ('Theremin'),
       ('Violin'),
       ('Tuba'),
       ('Melodica'),
       ('Trombone'),
       ('Keyboard');

-- Buy some instruments.
-- Create a prepared statement for this; to allow you to reset the
-- database when debugging.
INSERT INTO instruments (instrument_type)
VALUES ('Guitar'),      -- 1
       ('Trumpet'),     -- 2
       ('Flute'),       -- 3
       ('Theremin'),    -- 4
       ('Violin'),      -- 5
       ('Tuba'),        -- 6
       ('Melodica'),    -- 7
       ('Trombone'),    -- 8
       ('Melodica'),    -- 9
       ('Keyboard'),    -- 10
       ('Melodica');    -- 11

-- Now check out some instruments to students.
INSERT INTO student_instruments (student_id, instrument_id)
VALUES (1,  1),
       (2,  2),
       (3,  3),
       (3,  4),
       (4,  7),
       (2,  9),
       (1, 11);


-- INSERT INTO student_instruments (student_id, instrument_id, check_in_date)
-- VALUES (1 , 3, '2020-10-01');
