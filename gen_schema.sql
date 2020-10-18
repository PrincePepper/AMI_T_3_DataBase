DROP TABLE IF EXISTS FLIGHT CASCADE;
DROP TABLE IF EXISTS Commander;
DROP TABLE IF EXISTS Planet;
DROP TABLE IF EXISTS Spacecraft;

CREATE TABLE Spacecraft(
  id SERIAL PRIMARY KEY,
  name TEXT UNIQUE,
  service_life INT DEFAULT 1000,
  birth_year INT
);

CREATE TABLE Planet(
  id SERIAL PRIMARY KEY,
  name TEXT UNIQUE,
  distance NUMERIC(5,2)
);

CREATE TABLE Commander(
  id SERIAL PRIMARY KEY,
  name TEXT
);

CREATE TABLE Flight(
  id INT PRIMARY KEY,
  spacecraft_id INT REFERENCES Spacecraft,
  planet_id INT REFERENCES Planet,
  commander_id INT REFERENCES Commander,
  start_date DATE,
  UNIQUE(spacecraft_id, start_date),
  UNIQUE(commander_id, start_date)
);
















INSERT INTO Spacecraft(name, birth_year)
SELECT unnest(ARRAY[
      'Кедр', 'Орел', 'Сокол', 'Беркут', 'Ястреб', 'Чайка', 'Рубин', 'Алмаз', 'Аргон', 'Амур', 'Байкал', 'Антей', 'Буран'
  ]), 2117 + (random()*50)::INT;


WITH Names AS (
  SELECT unnest(ARRAY['Громозека', 'Ким', 'Буран', 'Зелёный', 'Горбовский', 'Ийон Тихий', 'Форд Префект', 'Комов', 'Каммерер']) AS name
)
INSERT INTO Commander(name)
SELECT name FROM Names;

WITH PlanetNames AS (
  SELECT unnest(ARRAY[
    'Tibedied', 'Qube', 'Leleer', 'Biarge', 'Xequerin', 'Tiraor', 'Rabedira', 'Lave',
    'Zaatxe', 'Diusreza', 'Teaatis', 'Riinus', 'Esbiza', 'Ontimaxe', 'Cebetela', 'Ceedra',
    'Rizala', 'Atriso', 'Teanrebi', 'Azaqu', 'Retila', 'Sotiqu', 'Inleus', 'Onrira', 'Ceinzala',
    'Biisza', 'Legees', 'Quator', 'Arexe', 'Atrabiin', 'Usanat', 'Xeesle', 'Oreseren', 'Inera',
    'Inus', 'Isence', 'Reesdice', 'Terea', 'Orgetibe', 'Reorte', 'Ququor', 'Geinona',
    'Anarlaqu', 'Oresri', 'Esesla', 'Socelage', 'Riedquat', 'Gerege', 'Usle', 'Malama',
    'Aesbion', 'Alaza', 'Xeaqu', 'Raoror', 'Ororqu', 'Leesti', 'Geisgeza', 'Zainlabi',
    'Uscela', 'Isveve', 'Tioranin', 'Learorce', 'Esusti', 'Ususor', 'Maregeis', 'Aate',
    'Sori', 'Cemave', 'Arusqudi', 'Eredve', 'Regeatge', 'Edinso', 'Ra', 'Aronar',
    'Arraesso', 'Cevege', 'Orteve', 'Geerra', 'Soinuste', 'Erlage', 'Xeaan', 'Veis',
    'Ensoreus', 'Riveis', 'Bivea', 'Ermaso', 'Velete', 'Engema', 'Atrienxe', 'Beusrior',
    'Ontiat', 'Atarza', 'Arazaes', 'Xeeranre', 'Quzadi', 'Isti', 'Digebiti', 'Leoned',
    'Enzaer', 'Teraed'
  ]) AS name
)
INSERT INTO Planet(name, distance)
SELECT name, (random() * 1000)::numeric(5,2)
FROM PlanetNames;

WITH MaxValues AS (
  SELECT (SELECT MAX(id) FROM Spacecraft) AS spacecraft,
  (SELECT MAX(id) FROM Commander) AS commander,
  (SELECT MAX(id) FROM Planet) AS planet
),
FlightIds AS (
  SELECT generate_series(1, 500) AS id
),
RawFlights AS (
  SELECT id, (0.5 + random()*spacecraft)::INT AS spacecraft_id,
      (0.5 + random()*commander)::INT AS commander_id,
      (0.5 + random()*planet)::INT AS planet_id,
      ('2184-01-01'::DATE + random()*365*5 * INTERVAL '1 day')::DATE AS date
  FROM MaxValues CROSS JOIN FlightIds
),
DistinctCommanders AS (
  SELECT commander_id, date, MAX(id) AS id, MAX(planet_id) AS planet_id
  FROM RawFlights
  GROUP BY commander_id, date
  HAVING COUNT(1) = 1
),
DistinctSpacecrafts AS (
  SELECT spacecraft_id, date, MAX(id) AS id
  FROM RawFlights
  GROUP BY spacecraft_id, date
  HAVING COUNT(1) = 1
)
INSERT INTO Flight(id, spacecraft_id, commander_id, planet_id, start_date)
SELECT DC.id, DS.spacecraft_id, DC.commander_id, DC.planet_id, DC.date
FROM DistinctCommanders DC JOIN DistinctSpacecrafts DS USING(id);

