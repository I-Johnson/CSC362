USE red_river_climbs;
-- 1. Show all the climbs in the database graded 5.10a and under.
SELECT climb_name, grade_str
  FROM climbs
       INNER JOIN climb_grades
       ON climbs.climb_grade = climb_grades.grade_id
 WHERE climbs.climb_grade <= (
          SELECT grade_id
            FROM climb_grades
           WHERE grade_str = '5.10a'
          );

-- 2. Show all the crags with 8 or more routes.
  SELECT climb_name, 
         crag_name, 
         COUNT(crag_name) AS num_routes 
    FROM climbs 
GROUP BY crag_name 
  HAVING num_routes > 8;



-- 3. Show all the crags with 3 or more routes graded 5.10a.
  SELECT crag_name, 
         COUNT(grade_str) AS num_10a_s, 
         GROUP_CONCAT(climb_name) AS route_names -- show the names of those 5.10a's just for fun
    FROM climbs 
         INNER JOIN climb_grades
         ON climb_grade = grade_id
   WHERE grade_str = '5.10a'
GROUP BY crag_name
  HAVING num_10a_s >= 3;

-- Challenge:
-- 4. Show all the crags with fewer than 3 routes graded 5.9 or less.


DROP FUNCTION IF EXISTS get_grade_id;
CREATE FUNCTION get_grade_id (grd_str CHAR(5))
RETURNS INT
RETURN (SELECT grade_id FROM climb_grades WHERE climb_grades.grade_str = grd_str);


DROP FUNCTION IF EXISTS get_grade_id2;
DELIMITER //
CREATE FUNCTION get_grade_id2 (grd_str CHAR(5))
RETURNS INT
BEGIN
DECLARE id_num INT; -- If you want to set variables, you can do this.
SET id_num = (SELECT grade_id FROM climb_grades WHERE climb_grades.grade_str = grd_str);
RETURN id_num;
END //
DELIMITER ;


SELECT * FROM climbs WHERE climb_grade = get_grade_id('5.10a');
SELECT * FROM climbs WHERE climb_grade = get_grade_id2('5.10a');