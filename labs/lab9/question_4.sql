USE red_river_climbs;

DROP VIEW IF EXISTS listed_climbs;

CREATE VIEW listed_climbs AS
    SELECT 
        c.climb_name, 
        c.climb_grade, 
        c.climb_len_ft AS length, 
        c.crag_name,
        CONCAT(fa_c.climber_first_name, ' ', fa_c.climber_last_name) AS first_ascent,
        CONCAT(dev_c.climber_first_name, ' ', dev_c.climber_last_name) AS developed_by
    FROM climbs AS c
    LEFT JOIN first_ascents AS fa ON c.climb_id = fa.climb_id
    LEFT JOIN climbers AS fa_c ON fa.climber_id = fa_c.climber_id
    LEFT JOIN developed_climbs AS dev ON c.climb_id = dev.climb_id
    LEFT JOIN climbers AS dev_c ON dev.climber_id = dev_c.climber_id
    WHERE fa_c.climber_first_name IS NOT NULL AND dev_c.climber_first_name IS NOT NULL;

SELECT * FROM listed_climbs;
