-- Geometry missingness for the thesis scenarios (the geometry exchange:
-- KQML :missing-geometries / :found-geometries). Agent-1 holds these places
-- WITHOUT their geometry ("geometry-null": the row exists, the column is NULL),
-- so a question that needs them makes Agent-1 ask Agent-2, which has them.
--
-- Runs after 20_agent1_data.sql, which loads the full data from
-- github.com/ishancoderr/germany-demographics-births-marriages. These are the
-- only differences between that data and Agent-1's database.

-- A state polygon: Berlin.
UPDATE states SET geo_shape = NULL
 WHERE state_id = 3 AND state_name = 'Berlin';

-- City points: Munich (scenario 11, a single point) and five more cities.
UPDATE cities SET centroid = NULL
 WHERE (city_id, city_name) IN (
       (5,    'Munich'),
       (121,  'Aschaffenburg'),
       (711,  'Alzey'),
       (802,  'Babenhausen'),
       (1049, 'Aßlar'),
       (1517, 'Bad Ems'));

-- Fail the first start loudly if the data did not match (nothing changed).
DO $$
BEGIN
  IF (SELECT count(*) FROM states WHERE geo_shape IS NULL) <> 1
     OR (SELECT count(*) FROM cities WHERE centroid IS NULL) <> 6 THEN
    RAISE EXCEPTION 'geometry gaps not applied as expected — check 20_agent1_data.sql';
  END IF;
END $$;
