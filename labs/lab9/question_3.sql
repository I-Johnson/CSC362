CREATE VIEW top_equippers AS
    SELECT climber_id, COUNT(*) AS established_num
    FROM developed_climbs
        GROUP BY climber_id
        ORDER BY established_num DESC
        LIMIT 3;
    
SELECT * FROM top_equippers;