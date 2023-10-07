-- Compute climber id from fname, lname.
CREATE FUNCTION name_to_climber_id (fname VARCHAR(32), lname VARCHAR(32))
RETURNS INT
RETURN (SELECT climber_id FROM climbers WHERE (climber_first_name = fname AND climber_last_name = lname));


UPDATE climbs
   SET first_ascent_id = name_to_climber_id('Will', 'Bailey')
 WHERE first_ascent_id = NULL;
