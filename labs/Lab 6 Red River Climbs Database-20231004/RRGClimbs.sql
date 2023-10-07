INSERT INTO climbs (climb_name, climb_grade, crag_name, climb_len_ft)
    VALUES ('Grand Bohemian',       12, 'Monastery', 70), -- 1 sport
           ('Nomad',                12, 'Monastery', 75), -- 2 sport
           ('Mission Creep',        11, 'Monastery', 60), -- 3 sport
           ('The Heretic',           8, 'Monastery', 45) , -- 4 trad
           ('Spork',                11, 'Monastery', NULL), -- 5 mixed route, with elements of sport AND trad.
           ('Vagabond',             12, 'Monastery', 65), -- 6 
           ('Parajna',              12, 'Monastery', 50), -- 7
           ('Licifer''s Unicycle',  10, 'Monastery', 60), -- 8
           ('Choss Gully Wrangling', 8, 'Monastery', 80), -- 9
           ('Return to Balance',    11, 'Slab City', 50), -- 10
           ('Child of the Earth',   12, 'Slab City', 60), -- 11
           ('Sacred Stones',        11,	'Slab City', 65), -- 12
           ('Go West',	             7,	'Slab City', 70), -- 13 trad
           ('Flash Point',          12,	'Slab City', 45), -- 14 trad
           ('Strip the Willows',    11, 'Slab City', 80), -- 15
           ('Thrillbillies',        10,	'Slab City', 90), -- 16
           ('Iron Lung',            12, 'Slab City', 50), -- 17
           ('Narcissus',            13, 'Monastery', 40); -- 18

INSERT INTO sport_climbs (climb_id, climb_bolts)
    VALUES ( 1, 10), -- Grand Bohemian has 10 bolts,
           ( 5,  4), -- Spork has 4 bolts.
           (10,  5),
           (11,  6),
           (12,  7),
           (15,  8),
           (16,  9),
           (17,  6);

INSERT INTO trad_climbs (climb_id, climb_descent)
    VALUES ( 4, 'rap rings'),      -- The Heretic has a bolt anchor to descend on.
           ( 5, 'rap rings'),      -- Spork has a bolt anchor to descend on.
           (13, 'rap rings'),
           (14, 'rap rings');

INSERT INTO developed_climbs (climb_id, climber_id, developed_date)
    VALUES ( 1,  1, '1998-9-2'),
           (10,  1, '2003-8-2'),
           ( 8, 54, '2014-1-1'),
           ( 3,  2, '2013-1-1'),
           ( 6,  2, '2013-1-1'),
           (18, 54, '2013-1-1'),
           (18, 55, '2014-1-1');

INSERT INTO first_ascents (climber_id, climb_id, first_ascent_date)
    VALUES (2, 1, '2004-1-1'),
           (2, 2, '2013-1-1'),
           (54, 8, '2014-1-1'),
           (55, 8, '2014-1-1'),
           (56, 10, '2005-1-1'),
           (57, 10, '2005-1-1'),
           (58, 10, '2005-1-1'),
           (54, 18, '2014-1-1'),
           (55, 18, '2014-1-1');

-- Q: Can we insert into a view? 
-- A: "Can not modify more than one base table through a join view"