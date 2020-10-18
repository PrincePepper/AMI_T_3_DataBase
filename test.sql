
DROP TABLE IF EXISTS Lesson;
DROP TABLE IF EXISTS Student;
DROP TABLE IF EXISTS Subject;

CREATE TABLE Student (
    id SERIAL PRIMARY KEY,
    name VARCHAR UNIQUE
);

CREATE TABLE Subject (
    id SERIAL PRIMARY KEY,
    name varchar UNIQUE
);

CREATE TABLE Lesson(
    student_id INT REFERENCES Student NOT NULL ,
    subject_id INT REFERENCES Subject NOT NULL ,
    date DATE NOT NULL ,
    num INT CHECK ( num > 0 AND num < 7 ) NOT NULL ,
    UNIQUE (student_id, date, num)
);

INSERT INTO Student(name) VALUES ('Вася'), ('Петя'), ('Коля');
INSERT INTO Subject(name) VALUES ('ООП'), ('БД'), ('python');

SELECT * FROM Student;
SELECT * FROM Subject;

INSERT INTO Student(name) VALUES ('Вася');
INSERT INTO Subject(name) VALUES ('ООП');

INSERT INTO Lesson (student_id, subject_id, date, num) VALUES (1, 1, '2020-10-30', 3);
INSERT INTO Lesson (student_id, subject_id, date, num) VALUES (60, 1, '2020-09-30', 4);
INSERT INTO Lesson (student_id, subject_id, date, num) VALUES (1, 40, '2020-09-30', 3);
INSERT INTO Lesson (student_id, subject_id, date, num) VALUES (1, 2, '2020-09-30', 3);


INSERT INTO Lesson (student_id, subject_id, date, num)
VALUES (
        (SELECT id FROM Student WHERE name = 'Коля'),
        (SELECT id FROM Subject WHERE name = 'ООП'),
        '2020-09-30',
        4
);

SELECT St.name, Su.name, Lesson.date, Lesson.num
FROM Lesson
    JOIN Student AS St on Lesson.student_id = St.id
    JOIN Subject Su on Su.id = Lesson.subject_id;
