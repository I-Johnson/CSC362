USE red_river_climbs;

SELECT * FROM climb_grades;

UPDATE climb_grades
    SET grade_str = '5.10a'

WHERE grade_str = '5.10';