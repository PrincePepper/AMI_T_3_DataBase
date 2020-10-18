-- Выберем все данные для анализа
SELECT
    c.name As commander,
    p.name As planet,
    p.distance As planet_distance,
    s.name As spacecraft,
    flight.start_date
FROM flight
    JOIN commander c on c.id = flight.commander_id
    JOIN planet p on flight.planet_id = p.id
    JOIN spacecraft s on s.id = flight.spacecraft_id;


SELECT * FROM flight;

--Агрегатные функции
SELECT min(start_date) FROM flight; -- MIN MAX AVG COUNT SUM
SELECT min(start_date), max(commander_id) FROM flight;

--Немного о Count
SELECT COUNT() FROM flight;
SELECT COUNT(*) FROM flight;
SELECT COUNT(1) FROM flight;
SELECT COUNT(commander_id) FROM flight;
SELECT COUNT(DISTINCT commander_id) FROM flight ;

SELECT COUNT(1);
SELECT COUNT(NULL);


--Поиск минимальной даты для конкретного пилота
SELECT min(start_date)
FROM flight
    JOIN commander c on c.id = flight.commander_id
    WHERE c.name = 'Зелёный';

--Поиск минимальной даты для каждого пилота
FOR id As c_id FROM commander
SELECT min(start_date) FROM flight WHERE commander_id = id;

SELECT
       name,
       (SELECT min(start_date) FROM flight c2 WHERE c1.id = c2.commander_id)--,
       --(SELECT min(start_date) from flight WHERE commander_id = commander.id)
FROM commander c1;

SELECT * FROM flight;

--Группировка
SELECT commander_id, min(start_date) FROM flight GROUP BY commander_id;
SELECT COUNT(*) FROM flight GROUP BY commander_id;

SELECT commander.name, min(start_date)
FROM flight
JOIN commander on flight.commander_id = commander.id
GROUP BY commander.name;


--Минимальная дата для каждого пилота с использованием группировки
SELECT c.name, min(start_date)
FROM flight
    JOIN commander c on flight.commander_id = c.id
GROUP BY flight.commander_id;


SELECT c.name, min(start_date)
FROM flight
    JOIN commander c on flight.commander_id = c.id
GROUP BY c.id;


-- Фильтрация по агрегатной функции
SELECT c.name, COUNT(*)
FROM flight
    JOIN commander c on flight.commander_id = c.id
GROUP BY c.id;


SELECT c.name, COUNT(*)
FROM flight
    JOIN commander c on flight.commander_id = c.id
WHERE COUNT(*) > 50
GROUP BY c.id;


-- Появление having
SELECT c.name, COUNT(*)
FROM flight
    JOIN commander c on flight.commander_id = c.id
GROUP BY c.id
HAVING COUNT(*) > 50;

--Поиск строки по агрегатной функции
SELECT min(start_date), commander_id FROM flight;
SELECT commander_id FROM flight WHERE start_date = MIN(start_date);
SELECT commander_id FROM flight HAVING start_date = MIN(start_date);

SELECT commander_id
FROM flight
WHERE start_date = (
    SELECT MIN(start_date) from flight
    );



SELECT c.name, start_date
FROM flight
JOIN commander c on c.id = flight.commander_id
WHERE start_date = (
    SELECT MIN(start_date) from flight
    );


-- Не-всегда-рабочий аналог
SELECT flight.start_date, flight.commander_id
FROM flight
ORDER BY start_date DESC
LIMIT 1;


--всегда-рабочий аналог
SELECT COUNT(*)
FROM flight
GROUP BY commander_id
ORDER BY COUNT(*) desc
LIMIT 5;


SELECT c.name, COUNT(*)
FROM flight
JOIN commander c on c.id = flight.commander_id
GROUP BY c.id
HAVING COUNT(*) IN (
    SELECT DISTINCT COUNT(*)
    FROM flight
    GROUP BY commander_id
    ORDER BY COUNT(*) desc
    LIMIT 5
    )
ORDER BY COUNT(*) DESC;

-- волшебная WITH
WITH Top5FlightCount AS (
    SELECT DISTINCT COUNT(*)
    FROM flight
    GROUP BY commander_id
    ORDER BY COUNT(*) desc
    LIMIT 5
)
SELECT c.id, c.name, COUNT(*)
FROM flight
JOIN commander c on c.id = flight.commander_id
GROUP BY c.id
HAVING COUNT(*) IN (SELECT * FROM Top5FlightCount)
ORDER BY COUNT(*) desc;


--безумный пример волшебства WITH
WITH CommanderFlightCount AS (
    SELECT commander_id, COUNT(*)
    FROM flight
    GROUP BY commander_id
),
BetterThenCommander AS (
    SELECT
           l.commander_id AS looser_id,
           l.count AS looser_count,
           r.commander_id AS winner_id,
           r.count AS winner_count
    FROM CommanderFlightCount l
    LEFT JOIN CommanderFlightCount r -- RIGHT INNER
        on r.count > l.count
),
CountOfBetters As (
    SELECT
           looser_id As commander_id,
           COUNT(winner_id) As winners_count
    FROM BetterThenCommander
    GROUP BY looser_id
),
BestResults AS (
    SELECT DISTINCT winners_count
    FROM CountOfBetters
    ORDER BY winners_count
    LIMIT 5
),
BestCommanderId AS (
    SELECT commander_id
    FROM CountOfBetters WHERE winners_count IN (
        SELECT * FROM BestResults
    )
    ORDER BY winners_count
)
SELECT commander.name, cfc.count FROM BestCommanderId
JOIN CommanderFlightCount cfc ON BestCommanderId.commander_id = cfc.commander_id
JOIN commander ON commander.id = cfc.commander_id
ORDER BY cfc.count desc;





--Безумный пример без использования with
SELECT commander.name, COUNT(*) FROM (
    SELECT commander_id
    FROM (
        SELECT
           looser_id As commander_id,
           COUNT(winner_id) As winners_count
        FROM (
             SELECT
                   l.commander_id AS looser_id,
                   r.commander_id AS winner_id
            FROM (
                SELECT commander_id, COUNT(*)
                FROM flight
                GROUP BY commander_id
            ) l
            LEFT JOIN (
                SELECT commander_id, COUNT(*)
                FROM flight
                GROUP BY commander_id
            ) r
            on r.count > l.count
        ) foo1
        GROUP BY looser_id
    ) bar1
    WHERE winners_count IN (
        SELECT DISTINCT winners_count
        FROM (
            SELECT
                   COUNT(winner_id) As winners_count
            FROM (
                 SELECT
                       l.commander_id AS looser_id,
                       r.commander_id AS winner_id
                FROM (
                    SELECT commander_id, COUNT(*)
                    FROM flight
                    GROUP BY commander_id
                ) l
                LEFT JOIN (
                    SELECT commander_id, COUNT(*)
                    FROM flight
                    GROUP BY commander_id
                ) r
                on r.count > l.count
            ) foo2
            GROUP BY looser_id
        ) bar2
        ORDER BY winners_count
        LIMIT 5
    )
    ORDER BY winners_count
) foo3
JOIN commander on commander_id = commander.id
JOIN flight f on commander.id = f.commander_id
GROUP BY commander.name;


SELECT * FROM flight WHERE id = 209;
