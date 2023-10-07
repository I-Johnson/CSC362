USE red_river_climbs;
/*
    An example procedure, which adds records to climbs, sport_climbs, 
    and trad_climbs in sequence.
*/
SET @cid = 0;

DROP PROCEDURE IF EXISTS add_new_climb;
DELIMITER //
CREATE PROCEDURE add_new_climb (
    IN new_climb_name      VARCHAR(80),
    IN new_climb_crag      VARCHAR(64),
    IN new_climb_grade     INT,
    IN new_climb_len_ft    INT,
    IN new_climb_bolts     INT,    -- sport only
    IN new_climb_descent   ENUM('rap from tree', 'walk off', 'rap rings')    -- trad only
)
BEGIN
    -- Add to climbs table, getting the id of the new climb.
        INSERT INTO climbs (climb_name, climb_grade, crag_name, climb_len_ft)
         VALUES (new_climb_name, new_climb_grade, new_climb_crag, new_climb_len_ft)
      RETURNING @cid := climb_id;
    -- Look Ma! No possibility for confusion about the ID of the climb I just inserted!
    /*
    So, funny story: You cannot set a local variable with a SELECT .. RETURNING statement.
    You can only (as of 2022-10-31) set a session variable. So I think it this is going to 
    be a useful procedure, it will need to have a session variable created automatically.
    Perhaps this can be placed into a script or query that is executed each time, allowing
    a session variable which is transparent to the application.
    */
    -- Add to sport climbs table, if needed.
    IF new_climb_bolts IS NOT NULL THEN
        INSERT INTO sport_climbs (climb_id, climb_bolts)
             VALUES (@cid, new_climb_bolts);
    END IF;

    -- Add to trad climbs table, if needed.
    IF new_climb_descent IS NOT NULL THEN
        INSERT INTO trad_climbs (climb_id, climb_descent)
             VALUES (@cid, new_climb_descent);
    END IF;
END;
//
DELIMITER ;

-- INSERT INTO climbs (climb_name, climb_grade, crag_name, climb_len_ft)
-- VALUES ("Tyranasaurs Flex", 12, "The Boneyard", 92)
-- RETURNING climb_id;

-- DELETE FROM climbs WHERE climb_name = "Tyranasaurs Flex";
-- CALL add_new_climb("Tyranasaurs Flex", "The Boneyard", 14, 102, 45, 'rap from tree'); -- , 'rap from tree');
/*
    An example trigger, which checks that the date of a first ascent is 
    after the date a climb_is established.
*/
DROP TRIGGER IF EXISTS check_fa_est_date;
DELIMITER //
CREATE TRIGGER check_fa_est_date 
BEFORE INSERT ON first_ascents FOR EACH ROW
BEGIN
    DECLARE est_date DATE;
    SET est_date = (SELECT developed_date FROM developed_climbs WHERE climb_id = NEW.climb_id);
    IF est_date > NEW.first_ascent_date THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'First ascent date must be after established date!';
    END IF;
END;
//
DELIMITER ;