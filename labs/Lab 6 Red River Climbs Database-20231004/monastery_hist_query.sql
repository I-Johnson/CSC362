-- Big Example Query From Monday 11 Oct, and Wednesday 13 Oct. 
USE red_river_climbs; -- Note that you must establish this database first. Code is on Moodle.

/*
GOAL: Show the number of routes at each grade, even if zero, at the Monestary crag.
*/

DROP VIEW IF EXISTS climbs_with_grades;

CREATE VIEW climbs_with_grades AS
SELECT *
  FROM climbs
       INNER JOIN climb_grades 
       ON (climbs.climb_grade=climb_grades.grade_id);

-- Generate all possible grades for Monastery.
DROP VIEW IF EXISTS monastery_possible_grades;

CREATE VIEW monastery_possible_grades AS 
SELECT crag_name, grade_str, grade_id
  FROM crags 
       CROSS JOIN climb_grades
 WHERE crag_name='Monastery';

-- Now outer join those two into a single table.
SELECT * 
  FROM monastery_possible_grades 
       LEFT OUTER JOIN climbs_with_grades 
       ON (monastery_possible_grades.grade_str=climbs_with_grades.grade_str AND 
           monastery_possible_grades.crag_name=climbs_with_grades.crag_name);

-- Finally, group and aggregate the tedious table above.
SELECT monastery_possible_grades.grade_str, COUNT(climb_name), GROUP_CONCAT(climb_name)
  FROM monastery_possible_grades 
       LEFT OUTER JOIN climbs_with_grades 
       ON (monastery_possible_grades.grade_str=climbs_with_grades.grade_str AND 
           monastery_possible_grades.crag_name=climbs_with_grades.crag_name)
 GROUP BY monastery_possible_grades.grade_id
 ORDER BY monastery_possible_grades.grade_id ASC;

-- Make this into a stored procedure, accepting a single argument, (crag name)
-- The output could be fed directly into a program for generating a historgram.