-- From in-class examples on 2021-10-06

-- GENERAL QUERIES
-- 1. Show the name of every climb in the database.
-- SELECT climb_name FROM climbs;

-- -- 2. Show the name and grade of every trad climb in the database.
-- SELECT climb_name, grade_str 
--   FROM trad_climbs_view 
--        INNER JOIN climb_grades 
--        ON (climb_grade=grade_id);

--     -- Alternatively, without using the trad climbs view:
-- SELECT climb_name, grade_str 
--   FROM climbs 
--        INNER JOIN trad_climbs 
--        USING (climb_id)

--        INNER JOIN climb_grades 
--        ON (climb_grade=grade_id);

-- -- 3. Show the name, grade, and height of each trad sport in the database.
-- SELECT climb_name, grade_str, climb_bolts
--   FROM sport_climbs_view
--        INNER JOIN climb_grades
--        ON (climb_grade=grade_id);

--     -- Alternatively, without using the sport climbs view:
--     SELECT climb_name, grade_str, climb_bolts
--       FROM climbs
--            INNER JOIN sport_climbs
--            USING (climb_id)

--            INNER JOIN climb_grades
--            ON (climb_grade=grade_id);

-- -- FILTERING QUERIES
-- -- 4. Show all the information about every sport climb at the 'Slab City' crag.
-- SELECT climb_name, climb_bolts
--   FROM sport_climbs_view
--        WHERE crag_name = 'Slab City';

-- -- 5. Show the name, crag, and grade of all trad climbs in the 'Muir Valley' region.
-- SELECT climb_name, grade_str, crag_name
--   FROM trad_climbs_view
--        INNER JOIN climb_grades
--        ON (climb_grade=grade_id)

--        INNER JOIN crags
--        USING (crag_name)
--  WHERE region_name='Muir Valley';

--  -- 6. Show the name, grade and crag, of everything graded 5.9.
-- SELECT climb_name, grade_str, crag_name
--   FROM climbs
--        INNER JOIN climb_grades ON (climb_grade=grade_id)
--        WHERE grade_id <= 
--        (
--          SELECT grade_id 
--            FROM climb_grades
--                 WHERE grade_str='5.9'
--        );

-- -- START HERE, 2021-10-11
-- -- 7. Count the number of routes of each difficulty level that appears in the database.
-- -- FIIRST ATTEMPT?
-- SELECT grade_str, COUNT(grade_str)
--   FROM climbs
--        INNER JOIN climb_grades ON (climb_grade=grade_id);

-- -- We need a GROUP BY clause:
-- SELECT grade_str, COUNT(grade_str)
--   FROM climbs
--        INNER JOIN climb_grades ON (climb_grade=grade_id);
-- -- But this "stacks records"! hiding the ones we want!

-- -- Aggregate the groups, to get the real answer:
-- SELECT grade_str, COUNT(grade_str)
--   FROM climbs
--        INNER JOIN climb_grades ON (climb_grade=grade_id)
--        GROUP BY grade_str;

-- -- Sort them to make it pretty:
-- SELECT grade_str, COUNT(grade_str)
--   FROM climbs
--        INNER JOIN climb_grades ON (climb_grade=grade_id)
--        GROUP BY grade_str
--        ORDER BY grade_id ASC;

-- -- SELECT grade_str, COUNT(grade_str)
-- --   FROM climbs
-- --        INNER JOIN climb_grades ON (climb_grade=grade_id)
-- --        GROUP BY grade_str
-- --        ORDER BY grade_id DESC;

-- -- 8. Show the names of all routes at each difficulty level
-- SELECT grade_str, GROUP_CONCAT(climb_name)
--   FROM climbs
--        INNER JOIN climb_grades ON (climb_grade=grade_id)
--        GROUP BY grade_str
--        ORDER BY grade_id ASC;

-- -- 9. Show the number of routes at each crag. REVISE: SHOW NAMES TOO!
-- SELECT crag_name, COUNT(*), GROUP_CONCAT(climb_name)
--   FROM climbs
--        GROUP BY crag_name;

-- -- APPLICATIONS OF THE LESS COMMON JOINS (OUTER, CROSS)
-- -- 10. Show the number of routes at EVERY difficulty level.
-- -- SELECT grade_str, COUNT(*), GROUP_CONCAT(climb_name)       -- THESE ARE NOT THE SAME
-- SELECT grade_str, COUNT(climb_name), GROUP_CONCAT(climb_name)
--   FROM climbs
--        RIGHT OUTER JOIN climb_grades ON (climb_grade=grade_id)
--        GROUP BY grade_str
--        ORDER BY grade_id;

-- -- 10. Show the number of routes at each difficulty level, at a particular crag.
-- SELECT grade_str, COUNT(climb_name)
--   FROM climbs 
--        INNER JOIN climb_grades ON (climb_grade=climb_id)
--        CROSS JOIN crags


-- -- Generate all possible grades for Monastery.
DROP VIEW IF EXISTS monastery_possible_grades;
CREATE VIEW monastery_possible_grades AS 
SELECT crag_name, grade_str, grade_id
  FROM crags 
       CROSS JOIN climb_grades
 WHERE crag_name='Monastery';

 -- Or any crag, for that matter;
DELIMITER //

DROP PROCEDURE IF EXISTS POSSIBLE_GRADES; //

CREATE PROCEDURE 
  POSSIBLE_GRADES( crg_nm VARCHAR(64) )
BEGIN  
   SELECT * 
     FROM crags
          CROSS JOIN climb_grades
    WHERE crag_name=crg_nm; 
END 
//

DELIMITER ;

-- -- Generate a table of all climbs and their grade strings.
-- CREATE VIEW climbs_with_grades AS
-- SELECT *
--   FROM climbs
--        INNER JOIN climb_grades 
--        ON (climbs.climb_grade=climb_grades.grade_id);

-- -- Now outer join those two into a single table.
-- SELECT * 
--   FROM monastery_possible_grades 
--        LEFT OUTER JOIN climbs_with_grades 
--        ON (monastery_possible_grades.grade_str=climbs_with_grades.grade_str AND 
--            monastery_possible_grades.crag_name=climbs_with_grades.crag_name);

-- Finally, group and aggregate the tedious table above.
SELECT monastery_possible_grades.grade_str, COUNT(climb_name), GROUP_CONCAT(climb_name)
  FROM monastery_possible_grades 
       LEFT OUTER JOIN climbs_with_grades 
       ON (monastery_possible_grades.grade_str=climbs_with_grades.grade_str AND 
           monastery_possible_grades.crag_name=climbs_with_grades.crag_name)
 GROUP BY monastery_possible_grades.grade_id
 ORDER BY monastery_possible_grades.grade_id ASC;

-- SELECT ...
--   FROM 
-- SELECT climb_name, grade_str
--   FROM climbs
--        INNER JOIN (
--         SELECT crag_name, grade_str
--           FROM crags 
--                CROSS JOIN climb_grades
--          WHERE crag_name='Monastery'
--        ) AS possible_grades
--        ON (climb_grade=climb_id);


-- SELECT climb_name, grade_str 
--   FROM (crags 
--        CROSS JOIN climb_grades) 
--        LEFT OUTER JOIN climbs ON (crags.crag_name=climbs.crag_name AND climb_grades.grade_id=climbs.climb_grade)
--  WHERE climbs.crag_name='Monastery';

