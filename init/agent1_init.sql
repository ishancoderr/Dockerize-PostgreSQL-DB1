-- Auto-init script for Agent 1 database
-- Loaded by postgres image on first startup (when data volume is empty)

-- Step 1: Connect to the database the container initializes.
-- NOTE: /docker-entrypoint-initdb.d scripts run during initdb and cannot create new DBs.
-- So we create tables inside the default DB provided by POSTGRES_DB (from .env).
-- If you want a separate DB like `agent1_db`, set POSTGRES_DB=agent1_db in .env.


-- Step 2: Enable PostGIS
CREATE EXTENSION IF NOT EXISTS postgis;

-- Step 3: Lands
CREATE TABLE IF NOT EXISTS lands (
  land_id     INT PRIMARY KEY,
  land_name   VARCHAR(100) NOT NULL,
  geo_shape   GEOMETRY DEFAULT NULL
);

INSERT INTO lands (land_id, land_name) VALUES
  (1, 'Baden-Württemberg'),
  (2, 'Bayern'),
  (3, 'Berlin'),
  (4, 'Brandenburg'),
  (5, 'Bremen'),
  (6, 'Hamburg'),
  (7, 'Hessen'),
  (8, 'Mecklenburg-Vorpommern'),
  (9, 'Niedersachsen'),
  (10, 'Nordrhein-Westfalen'),
  (11, 'Rheinland-Pfalz'),
  (12, 'Saarland'),
  (13, 'Sachsen'),
  (14, 'Sachsen-Anhalt'),
  (15, 'Schleswig-Holstein'),
  (16, 'Thüringen')
ON CONFLICT (land_id) DO NOTHING;

-- Step 4: Land statistics (partition)
CREATE TABLE IF NOT EXISTS land_stats (
  stat_id           SERIAL PRIMARY KEY,
  land_id           INT NOT NULL,
  stat_date         DATE DEFAULT NULL,
  population        BIGINT DEFAULT NULL,
  births_married    BIGINT DEFAULT NULL,
  births_unmarried  BIGINT DEFAULT NULL,
  CONSTRAINT fk_land FOREIGN KEY (land_id)
    REFERENCES lands (land_id) ON DELETE CASCADE
);

INSERT INTO land_stats (land_id, stat_date, population, births_married, births_unmarried)
VALUES
  (2, '2015-12-31', 12843514, NULL, NULL),
  (2, '2016-12-31', 12930751, NULL, NULL),
  (2, '2017-12-31', 12997204, NULL, NULL),
  (2, '2018-12-31', 13076721, NULL, NULL),
  (2, '2019-12-31', 13124737, NULL, NULL),
  (2, '2020-12-31', 13140183, NULL, NULL),
  (2, '2021-12-31', 13176989, 98462, 35859),
  (4, '2015-12-31', 2484826, NULL, NULL),
  (4, '2016-12-31', 2494648, NULL, NULL),
  (4, '2017-12-31', 2504040, NULL, NULL),
  (4, '2018-12-31', 2511917, NULL, NULL),
  (4, '2019-12-31', 2521893, NULL, NULL),
  (4, '2021-12-31', 2537868, NULL, NULL),
  (7, '2015-12-31', 6176172, NULL, NULL),
  (7, '2016-12-31', 6213088, NULL, NULL),
  (7, '2017-12-31', 6243262, NULL, NULL),
  (7, '2018-12-31', 6265809, NULL, NULL),
  (7, '2019-12-31', 6288080, NULL, NULL),
  (7, '2020-12-31', 6293154, 42510, 16879),
  (8, '2015-12-31', 1612362, NULL, NULL),
  (8, '2016-12-31', 1610674, NULL, NULL),
  (8, '2017-12-31', 1611119, NULL, NULL),
  (8, '2018-12-31', 1609675, NULL, NULL),
  (8, '2019-12-31', 1608138, NULL, NULL),
  (9, '2015-12-31', 7926599, NULL, NULL),
  (9, '2016-12-31', 7945685, NULL, NULL),
  (9, '2017-12-31', 7962775, NULL, NULL),
  (9, '2018-12-31', 7982448, NULL, NULL),
  (9, '2019-12-31', 7993608, NULL, NULL),
  (13, '2015-12-31', 4084851, NULL, NULL),
  (13, '2016-12-31', 4081783, NULL, NULL),
  (13, '2017-12-31', 4081308, NULL, NULL),
  (13, '2018-12-31', 4077937, NULL, NULL),
  (13, '2019-12-31', 4071971, NULL, NULL),
  (13, '2020-12-31', 4056941, 15085, 18298),
  (14, '2015-12-31', 2245470, NULL, NULL),
  (14, '2016-12-31', 2236252, NULL, NULL),
  (14, '2017-12-31', 2223081, NULL, NULL),
  (14, '2018-12-31', 2208321, NULL, NULL),
  (14, '2019-12-31', 2194782, NULL, NULL),
  (16, '2015-12-31', 2170714, NULL, NULL),
  (16, '2016-12-31', 2158128, NULL, NULL),
  (16, '2017-12-31', 2151205, NULL, NULL),
  (16, '2018-12-31', 2143145, NULL, NULL),
  (16, '2019-12-31', 2133378, NULL, NULL),
  (16, '2020-12-31', 2120237, 7363, 8628)
ON CONFLICT DO NOTHING;

-- Step 5: Cities
-- Create city table. You can later insert real city geometries and centroids.
-- NOTE: geometry can be stored in EPSG:4326 (WGS84) if that matches your data.
CREATE TABLE IF NOT EXISTS cities (
  city_id      INT PRIMARY KEY,
  city_name    VARCHAR(150) NOT NULL,
  land_id      INT NOT NULL REFERENCES lands(land_id) ON DELETE CASCADE,

  centroid      GEOMETRY DEFAULT NULL, -- Point
  geo_shape    GEOMETRY DEFAULT NULL   -- Polygon/MultiPolygon
);


-- Placeholder example rows (replace with your real cities)
-- INSERT INTO cities (city_id, city_name, land_id, centroid, geo_shape)
-- VALUES
--   (1, 'Musterstadt', 2,
--     ST_SetSRID(ST_MakePoint(11.5755, 48.1372), 4326),
--     ST_SetSRID(ST_GeomFromText('MULTIPOLYGON(((...)))'), 4326)
--   )
-- ON CONFLICT (city_id) DO NOTHING;

-- Helpful index
CREATE INDEX IF NOT EXISTS idx_cities_centroid ON cities USING GIST (centroid);
CREATE INDEX IF NOT EXISTS idx_cities_shape ON cities USING GIST (geo_shape);

