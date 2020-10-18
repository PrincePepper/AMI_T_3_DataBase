WITH FlightCount AS
(
    SELECT c.id, c.name, COUNT(flight.id) flight_count
    FROM Flight RIGHT JOIN commander c on flight.commander_id = c.id
    GROUP BY c.id
),
BestFlights As
(
    SELECT DISTINCT flight_count FROM FlightCount ORDER BY flight_count DESC LIMIT 3
)
SELECT * FROM FlightCount WHERE flight_count IN (SELECT * FROM BestFlights);


WITH FlightCount AS
(
    SELECT c.id, c.name, COUNT(flight.id) flight_count
    FROM Flight RIGHT JOIN commander c on flight.commander_id = c.id
    GROUP BY c.id
),
Ranks AS (
    SELECT name, flight_count, DENSE_RANK() OVER (ORDER BY flight_count DESC) As rank
    FROM FlightCount
)
SELECT * FROM Ranks WHERE rank <= 3;

/*
 ОТличие RANK и DENCE_RANK можно почитать на сайте
 http://www.sql-tutorial.ru/ru/book_rank_dense_rank_functions.html
 */


SELECT *, COUNT(*) OVER () FROM commander;

SELECT * FROM planet;
SELECT DISTINCT commander_id, COUNT(*) OVER (PARTITION BY commander_id) FROM flight;

SELECT commander_id, COUNT(*) FROM flight GROUP BY commander_id;


DROP TABLE IF EXISTS Exams;
DROP TABLE IF EXISTS Lessons;
DROP TABLE IF EXISTS Students;

CREATE TABLE Students (id SERIAL PRIMARY KEY, name VARCHAR NOT NULL );
CREATE TABLE Lessons (id SERIAL PRIMARY KEY , name VARCHAR NOT NULL );
CREATE TABLE Exams (
    id SERIAL PRIMARY KEY ,
    student_id INT REFERENCES Students NOT NULL ,
    lesson_id INT REFERENCES Lessons NOT NULL ,
    points INT NOT NULL CHECK (points >= 0 AND points <= 100),
    extra_points INT NOT NULL CHECK (extra_points >= 0 AND extra_points <= 10 ) DEFAULT 0);

INSERT INTO Students (name) VALUES ('Вася'), ('Петя'), ('Коля');
INSERT INTO Lessons (name) VALUES ('c++'), ('python'), ('ООП');
INSERT INTO Exams (student_id, lesson_id, points, extra_points) VALUES
    (1, 1, 70, 3),
    (1, 2, 80, 5),
    (1, 3, 90, 0),
    (2, 1, 100, 1),
    (2, 2, 60, 2),
    (3, 1, 70, 7);


SELECT
       Students.name,
       Lessons.name,
       points,
       row_number() OVER (PARTITION BY lesson_id ORDER BY points DESC) As rank_by_points
FROM Exams
JOIN Students ON Exams.student_id = Students.id
JOIN Lessons ON Exams.lesson_id = Lessons.id;


SELECT
       Students.name,
       Lessons.name,
       points,
       extra_points,
       dense_rank() OVER (PARTITION BY lesson_id ORDER BY extra_points DESC) As rank_by_e_points,
       dense_rank() OVER (PARTITION BY lesson_id ORDER BY points DESC) As rank_by_points
FROM Exams
JOIN Students ON Exams.student_id = Students.id
JOIN Lessons ON Exams.lesson_id = Lessons.id
ORDER BY lesson_id, rank_by_points;


SELECT
       Students.name,
       Lessons.name,
       points,
       extra_points,
       SUM(points) OVER (PARTITION BY student_id) AS point_sum,
       dense_rank() OVER (PARTITION BY lesson_id ORDER BY extra_points DESC) As rank_by_e_points,
       dense_rank() OVER (PARTITION BY lesson_id ORDER BY points DESC) As rank_by_points
FROM Exams
JOIN Students ON Exams.student_id = Students.id
JOIN Lessons ON Exams.lesson_id = Lessons.id
ORDER BY lesson_id, rank_by_points;


SELECT
       Students.name,
       Lessons.name,
       points,
       extra_points,
       SUM(points) OVER byStudent AS point_sum,
       dense_rank() OVER byLessonExtra As rank_by_e_points,
       dense_rank() OVER byLessonPoints As rank_by_points
FROM Exams
JOIN Students ON Exams.student_id = Students.id
JOIN Lessons ON Exams.lesson_id = Lessons.id
WINDOW
    byStudent As (
        PARTITION BY student_id
    ),
    byLessonExtra AS (
        PARTITION BY lesson_id ORDER BY extra_points DESC
    ), byLessonPoints AS (
        PARTITION BY lesson_id ORDER BY points DESC
    )
ORDER BY lesson_id, rank_by_points;


SELECT
       s.name,
       p.name,
       p.distance,
       flight.start_date,
       AVG(p.distance) OVER w
FROM flight
JOIN spacecraft s on flight.spacecraft_id = s.id
JOIN planet p on flight.planet_id = p.id
WINDOW w AS (
    PARTITION BY s.id
    ORDER BY flight.start_date
    ROWS BETWEEN A PRECEDING AND B
    );

-- UNBOUNDED PRECEDING
-- value PRECEDING
-- CURRENT ROW
-- value FOLLOWING
-- UNBOUNDED FOLLOWING

WITH FlightCount As(
    SELECT c.id, c.name, COUNT(*) FROM
    flight JOIN commander c on flight.commander_id = c.id
    GROUP BY c.id
)
SELECT *, first_value(count) over () - count
FROM FlightCount
ORDER BY count DESC;



WITH FlightCount As(
    SELECT c.id, c.name, COUNT(*) FROM
    flight JOIN commander c on flight.commander_id = c.id
    GROUP BY c.id
)
SELECT *, first_value(count) over () - count
FROM FlightCount
ORDER BY count DESC;


WITH FlightCount As(
    SELECT c.id, c.name, COUNT(*) FROM
    flight JOIN commander c on flight.commander_id = c.id
    GROUP BY c.id
)
SELECT *, lag(count) over (ORDER BY count DESC) - count
FROM FlightCount;

/*
 победить n-th value не удалось. ОШибка в разных типах (int, bigint),
 а приведение типов не работает с оконным ифункциями :(
 Так что пользуйтесь lag, lead

 https://postgrespro.ru/docs/postgresql/9.6/functions-window

 */

--row_number номер строки
--lag смещение вверх
--lead смещение вниз
--first_value первая строка
--last_value последняя строка
--nth_value н-ная строка