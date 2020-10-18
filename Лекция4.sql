SELECT * FROM flight WHERE id = 209;


DROP VIEW IF EXISTS FlightInfo;

CREATE VIEW FlightInfo AS
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


SELECT * FROM FlightInfo;

DROP FUNCTION IF EXISTS CommanderFlight;
CREATE OR REPLACE FUNCTION CommandefFlight(id_ integer) RETURNS integer AS $$
    BEGIN
        RETURN (SELECT count(*) FROM flight WHERE commander_id = id_ GROUP BY commander_id);
    end;
    $$
LANGUAGE plpgsql;

SELECT name, CommandefFlight(id) FROM commander;


CREATE OR REPLACE FUNCTION BestCommander() RETURNS SETOF integer AS $$
    DECLARE
        maxFlights integer;

        f RECORD;
    BEGIN
        SELECT MAX(count) INTO maxFlights FROM (
            SELECT COUNT(*) AS count FROM flight GROUP BY commander_id
        ) foo;

        FOR f IN
            SELECT commander_id, COUNT(*) FROM flight GROUP BY commander_id
        LOOP
            IF f.count = maxFlights THEN
                RETURN NEXT f.commander_id;
            END IF;
        END LOOP;
    end;
    $$
LANGUAGE plpgsql;


SELECT BestCommander()