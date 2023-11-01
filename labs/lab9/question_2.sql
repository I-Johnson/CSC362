SET FOREIGN_KEY_CHECKS=0;

-- Create a temporary table to store the climb_ids of the rows to be deleted
CREATE TEMPORARY TABLE tmp_climb_table AS (
    SELECT climb_id FROM developed_climbs
    WHERE developed_date >= NOW() - INTERVAL 1 YEAR
);
-- Delete the records of the climbs developed within the last year
DELETE FROM developed_climbs 
    WHERE climb_id IN (SELECT climb_id FROM tmp_climb_table);

-- Delete the associated climb records from the 'climbs' tabl
DELETE FROM climbs 
    WHERE climb_id IN (SELECT climb_id FROM tmp_climb_table);

-- Drop the temporary table storing recent climb IDs
DROP TABLE tmp_climb_table;

SET FOREIGN_KEY_CHECKS=1;
     