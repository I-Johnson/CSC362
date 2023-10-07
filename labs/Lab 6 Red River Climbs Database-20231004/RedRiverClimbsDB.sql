DROP DATABASE IF EXISTS red_river_climbs;
CREATE DATABASE red_river_climbs;

USE red_river_climbs;

-- Who owns the various regions. In reality, this needs to be at crag level.
CREATE TABLE owners (
    -- PRIMARY KEY (owner_name),
    -- owner_name  VARCHAR(64) NOT NULL
    owner_name VARCHAR(64) PRIMARY KEY
);

-- The regional locations of places to climb. Typically, this dictates where you park.
CREATE TABLE regions (
    -- PRIMARY KEY (region_name),
    region_name     VARCHAR(64) PRIMARY KEY,
    owner_name      VARCHAR(64) DEFAULT "United States Forest Service", -- USFS more restrictive than RRGCC, encourages developer caution.
    FOREIGN KEY (owner_name) REFERENCES owners (owner_name) ON DELETE RESTRICT
);

-- Currently, no support for "sectors" i.e., "Bird Cage" is it's own crag.
CREATE TABLE crags (
    PRIMARY KEY (crag_name),
    crag_name   VARCHAR(64),
    region_name VARCHAR(64),
    FOREIGN KEY (region_name) REFERENCES regions (region_name) ON DELETE NO ACTION, -- Remove closed crags without deleting Route info; restore it if/when they open up
    approach    TEXT
);

-- Systematize the grading scheme so that the DB can compare difficulties.
CREATE TABLE climb_grades (
    PRIMARY KEY (grade_id),
    grade_id    INT AUTO_INCREMENT NOT NULL,
    grade_str   CHAR(5)
);

CREATE TABLE climbs (
    PRIMARY KEY (climb_id),
    climb_id            INT AUTO_INCREMENT  NOT NULL,
    climb_name          VARCHAR(80) DEFAULT 'Open Project',
    climb_grade         INT,
    -- first_ascent_id     INT DEFAULT NULL,
    -- climb_equipped_by   INT DEFAULT NULL,
    crag_name           VARCHAR(64),
    climb_len_ft        INT,
    CHECK (climb_len_ft > 0), -- Climbs must not be stupidly short.
    FOREIGN KEY (crag_name) REFERENCES crags (crag_name) ON DELETE NO ACTION,
    FOREIGN KEY (climb_grade) REFERENCES climb_grades (grade_id) ON DELETE RESTRICT 
);

-- This is the subset table.
CREATE TABLE sport_climbs (
    PRIMARY KEY (climb_id),
    climb_id        INT AUTO_INCREMENT,
    climb_bolts     INT,
    FOREIGN KEY (climb_id) REFERENCES climbs (climb_id) ON DELETE RESTRICT
);

-- Another subset table for traditional climbs.
CREATE TABLE trad_climbs (
    PRIMARY KEY (climb_id),
    climb_id        INT AUTO_INCREMENT,
    climb_descent   ENUM('rap from tree', 'walk off', 'rap rings'),        -- Do as I say, not as I do.
    FOREIGN KEY (climb_id) REFERENCES climbs (climb_id) ON DELETE RESTRICT
);



-- Create some views for convenience.
CREATE VIEW sport_climbs_view AS 
SELECT * 
  FROM climbs 
       INNER JOIN sport_climbs
       USING (climb_id); 

CREATE VIEW trad_climbs_view AS 
SELECT * 
  FROM climbs 
       NATURAL JOIN trad_climbs; -- do as i say, not as i do.

CREATE VIEW mixed_climbs_view AS 
SELECT * FROM climbs 
         NATURAL JOIN sport_climbs 
         NATURAL JOIN trad_climbs;

-- -- If you're curious.
-- -- DESCRIBE sport_climbs_view;
-- -- DESCRIBE trad_climbs_view;

-- Store information about individual humans on the climbing scene, as climbers, developers.
CREATE TABLE climbers (
    PRIMARY KEY (climber_id),
    climber_id          INT AUTO_INCREMENT NOT NULL,
    climber_first_name  VARCHAR(32),
    climber_last_name   VARCHAR(32),
    climber_email       VARCHAR(128) UNIQUE,
    climber_handle      VARCHAR(32) -- Website username.
);

-- Relate climbers to the routes that they were the first to climb. FAs may consist of multiple people.
CREATE TABLE first_ascents (
    PRIMARY KEY (climber_id, climb_id),
    climber_id          INT NOT NULL,   -- No NULLs; if you don't know who made the FA, don't include them in this table.
    climb_id            INT NOT NULL,
    first_ascent_date   DATE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (climber_id) REFERENCES climbers (climber_id) ON DELETE NO ACTION,
    FOREIGN KEY (climb_id) REFERENCES climbs (climb_id) ON DELETE NO ACTION
);

-- Relate climbers to the routes that they established. Multiple names may be related to each climb.
CREATE TABLE developed_climbs (
    PRIMARY KEY (climber_id, climb_id),
    climber_id      INT NOT NULL,
    climb_id        INT NOT NULL,
    developed_date  DATE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (climber_id) REFERENCES climbers (climber_id) ON DELETE NO ACTION,
    FOREIGN KEY (climb_id) REFERENCES climbs (climb_id) ON DELETE NO ACTION
);

-- Behold: The most complicated query I have every written.
CREATE VIEW climbs_with_fa_est AS
SELECT climb_id,
       climb_name,
       grade_str,
       grade_id,
       climb_len_ft,
       crag_name,
       fa_names,
       GROUP_CONCAT(CONCAT(bolters.climber_first_name, " ", bolters.climber_last_name) SEPARATOR ', ') AS equip_names
 FROM (
       SELECT climb_id,
              climb_name,
              grade_id,
              grade_str, 
              climb_len_ft,
              crag_name,
              GROUP_CONCAT(CONCAT(fa_climbers.climber_first_name, " ", fa_climbers.climber_last_name) SEPARATOR ', ') AS fa_names
         FROM climbs
              INNER JOIN climb_grades ON climb_grade = grade_id
              LEFT OUTER JOIN first_ascents AS ascents USING (climb_id)
              LEFT OUTER JOIN climbers AS fa_climbers USING(climber_id)
        GROUP BY climb_id
      ) AS bonk 
      LEFT OUTER JOIN developed_climbs AS estabs USING (climb_id)
      LEFT OUTER JOIN climbers AS bolters USING (climber_id)
GROUP BY climb_id;

-- Populate the grades table with the needlessly complex grading scheme 
SOURCE ClimbGrades.sql;

-- Populate owners table with preliminary list.
SOURCE RRGOwners.sql;

-- Populate regions list with current regions list.
SOURCE RRGRegions.sql;

-- Populate climbers with some climbers.
SOURCE Climbers.sql;

-- Populate the crags table with two regions's worth.
SOURCE MuirValleyCrags.sql;
SOURCE MillerForkCrags.sql;

-- Populate the climbs table with some routes!
SOURCE RRGClimbs.sql;
	