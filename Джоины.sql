
SELECT id, name, (SELECT COUNT(*) FROM flight WHERE commander_id = commander.id)
FROM commander;



SELECT commander.id, commander.name, COUNT(*)
FROM commander JOIN flight f on commander.id = f.commander_id
GROUP BY commander.id;


SELECT commander.id, commander.name, COUNT(f.id)
FROM commander As c FULL OUTER JOIN flight f on commander.id = f.commander_id
GROUP BY commander.id;

--CROSS JOIN
--JOIN
--LEFT JOIN
--RIGHT [OUTER] JOIN
--FULL [OUTER] JOIN
--NATURAL JOIN

DROP TABLE IF EXISTS B;
DROP TABLE IF EXISTS A;

CREATE TABLE A (id SERIAL PRIMARY KEY , a_name VARCHAR);
CREATE TABLE B (id SERIAL PRIMARY KEY , a_id INT REFERENCES A, b_name VARCHAR);

INSERT INTO A (a_name) VALUES ('Веган'), ('Мясооед');
INSERT INTO B (a_id, b_name) VALUES
    (1, 'Трава'), (1, 'Внимание случайных прохожих'),
    (2, 'Трупы'), (2, 'Возможно души детей');


SELECT * FROM B;

SELECT * FROM A JOIN B ON A.id = B.id;

SELECT * FROM A NATURAL JOIN B;