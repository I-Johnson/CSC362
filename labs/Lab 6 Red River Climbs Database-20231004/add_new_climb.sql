DELIMITER //

CREATE PROCEDURE add_new_climb(
    new_climb_name      VARCHAR(80),
    new_climb_crag      VARCHAR(64),
    new_climb_grade     INT,
    new_climb_len_ft    INT,
    new_climb_bolts     INT,    -- sport only
    new_climb_descent   INT,    -- trad only
    new_climb_fa1       INT,    -- climber_ids
    new_climb_fa2       INT,
    new_climb_fa_date   DATE,
    new_climb_est1      INT,
    new_climb_est2      INT,
    new_climb_est_date  DATE
)

BEGIN;

    DECLARE new_climb_id INT;

    INSERT INTO climbs (climb_name, climb_grade, crag_name, climb_len_ft)
         VALUES (new_climb_name, new_climb_grade, new_climb_crag, new_climb_len_ft);

    -- Get the id of the new climb. Ideally, this would be validated perfectly somehow.
    SET new_climb_id = (
        SELECT climber_id
          FROM climbs
         WHERE climb_name = new_climb_name AND crag_name = new_climb_crag
    );

    IF new_climb_bolts IS NOT NULL THEN
        INSERT INTO sport_climbs (climb_id, climb_bolts)
             VALUES (new_climb_id, new_climb_bolts);
    END IF;

    IF new_climb_descent IS NOT NULL THEN
        INSERT INTO trad_climbs (climb_id, climb_descent)
             VALUES (new_climb_id, climb_descent)
    END IF;

    -- Add new entries into the developed_climbs table.
    IF new_climb_est1 IS NOT NULL THEN
        INSERT INTO developed_climbs (climber_id, climb_id, developed_date)
             VALUES (new_climb_est1, new_climb, new_climb_est_date);
    END IF;

    IF new_climb_est2 IS NOT NULL THEN
        INSERT INTO developed_climbs (climber_id, climb_id, developed_date)
             VALUES (new_climb_est2, new_climb_id, new_climb_est_date);
    END IF;

    -- Add new entries into the first_ascenionists table.
    IF new_climb_fa1 IS NOT NULL THEN
        INSERT INTO first_ascents (climber_id, climb_id, first_ascent_date)
             VALUES (new_climb_fa1, new_climb_id, new_climb_fa_date);
    END IF;

    IF new_climb_fa2 IS NOT NULL THEN
        INSERT INTO first_ascents (climber_id, climb_id, first_ascent_date)
             VALUES (new_climb_fa2, new_climb_id, new_climb_fa_date);
    END IF;

END;

//

DELIMITER ;