# AMI_T_3_DateBase
Предмет «Базы данных» 

Иcпользуется язык программирования SQL, все запросы написана на `SQLite3`.

### Страница задач контеста «SQL Б8119.01.03.02систпро» [CLICK](https://imcs.dvfu.ru/cats/?f=problems;cid=5073727)

Преподователи курса:  
       [Малявин Никита](https://github.com/FooBarrior)

***The project was released for my University course***

##### My contacts:
1. [Telegram](https://tgmsg.ru/princepepper)
2. [Вконтакте](https://vk.com/princepepper)
3. [Instargam](https://www.instagram.com/prince_pepper_official/?hl=ru)
4. <sereda.wk@gmail.com>

### Решение данного контеста
### Задача 1. Агрегатные функции
```
SELECT MIN(value) AS MinValue,
       MAX(value) AS MaxValue,
       SUM(value) AS SumValue,
       COUNT(value) AS CountValue,
       AVG(value) AS AvgValue
  FROM Numbers;
```
### Задача A. Удаление тестовой таблицы
```
DROP TABLE TestTable;
```
### Задача B. Удаление NULL-значений
```
DELETE FROM Magazines   
 WHERE Edition IS NULL;
```
### Задача C. Телефонный код города
```
 select PhoneCode from TelephoneCodesOfCities where City="krasnoyarsk";
```
### Задача D. Суммирование полей
```
select ABS(A+B) from ListOfNumbers
```
### Задача E. Сотрудники с низкой зарплатой
```
SELECT EmployeeFullNames, ROUND(SumSalary, 0)
FROM (
         SELECT e.FullName AS EmployeeFullNames, SUM(p.Salary * s.SalaryPercentage) AS SumSalary
         FROM (Employees e
                  JOIN Salaries s ON e.ID = s.EmployeeID
                  JOIN Positions p ON p.ID = s.PositionID)
         GROUP By e.FullName
     )
WHERE SumSalary < (
    SELECT AVG(SumSalary)
    FROM (select sum(Salary * SalaryPercentage) as SumSalary
          from Salaries a,
               Positions b,
               Employees c
          where c.ID == EmployeeID
            and b.ID == PositionID
          group by EmployeeID)
)
ORDER BY SumSalary ASC;
```
### Задача F. Сотрудники и пациенты больницы
```
select COUNT(*) as TotalPeopleWithMI
from (select PersonalDataID from Doctors UNION select PersonalDataID from Patients order by PersonalDataID) t3,
     MedicalInsurance t
where (select t2.MedicalInsuranceID from PersonalData t2 where t2.ID==t3.PersonalDataID) == t.ID
  and t.Status = 'active';
```
### Задача G. Сотрудники ИТ-отдела
```
CREATE VIEW ShowITEmployees AS
WITH RECURSIVE bosses AS (
SELECT e.ID, FullName, p.Title as Position, e.ChiefID
FROM Employees e
INNER JOIN Positions p on e.PositionID = p.ID
WHERE p.Title = 'PC Principal'
UNION
SELECT e2.ID, e2.FullName, p.Title as Position, e2.ChiefID
FROM Employees e1
INNER JOIN Employees e2 on e1.ID = e2.ChiefID
LEFT JOIN Positions p on e2.PositionID = p.ID
INNER JOIN bosses b on b.id = e2.ChiefID
)
SELECT * FROM bosses;
```
### Задача H. Создание таблицы с заметками
```
CREATE TABLE Notes (
ID INTEGER PRIMARY KEY AUTOINCREMENT,
Note TEXT NOT NULL UNIQUE,
TimeOfCreation DATETIME NOT NULL,
ProgressMade REAL DEFAULT (0)
CHECK (ProgressMade >= 0 and ProgressMade <= 1),
Status TEXT DEFAULT ('started')
CHECK (Status IN ('started','accepted','canceled')));

```
### Задача I. Создание простой базы контактов
```
CREATE TABLE contacts (id INTEGER PRIMARY KEY, name TEXT);

CREATE TABLE email (address TEXT,
contact_id INTEGER REFERENCES contacts (id));

CREATE TABLE phones (number TEXT,
contact_id INTEGER REFERENCES contacts (id));
```
### Задача K. Поиск клиентов по первой букве
```
SELECT FirstName 
  FROM Customers 
 WHERE FirstName LIKE 'G%'
 ORDER BY Age DESC;
```
### Задача L. Остатки товаров на складе
```
SELECT Products.Title, Categories.Name AS CategoryName, Products.SellingPrice
FROM Products
         LEFT JOIN Categories ON Products.CategoryID = Categories.ID
         JOIN (
    SELECT *
    FROM (
             SELECT SalesItems.ProductID soldID, sum(SalesItems.QuantitySold) sumSold
             FROM SalesItems
             GROUP BY SalesItems.ProductID)
             JOIN (
        SELECT PurchaseItems.ProductID purchaseID, sum(PurchaseItems.QuantityBought) sumBought
        FROM PurchaseItems
        GROUP BY PurchaseItems.ProductID)
                  ON purchaseID = soldID AND sumBought = sumSold)
              ON purchaseID = Products.ID
ORDER BY Products.SellingPrice DESC;
```
### Задача M. Опытные сотрудники
```
SELECT FullName 
  FROM Employees 
 WHERE Age BETWEEN 35 AND 70 AND Sex="male";
```
### Задача N. Обновление значений поля
```
UPDATE Animals SET Sex = CASE WHEN Sex = 'male' THEN 'm' WHEN Sex = 'female' THEN 'w' WHEN Sex IS NOT NULL THEN 'unknown' END;
```
### Задача O. Лучшие продавцы товаров
```
select t1.fname as SellerFullName, sum(t2.summa) as TotalRevenue, count(t1.fname) as CountOfSales
from (select Sales.id, LastName || ' ' || FirstName as fname
      from Sales,
           Sellers
      where SellerID == Sellers.ID) t1,
     (select SaleID as id, SUM(SellingPrice * QuantitySold) as summa, sum(QuantitySold) as QuantitySold
      from Products,
           SalesItems
      where ProductID == Products.ID
      group by SaleID) t2
where t1.ID == t2.id
group by t1.fname
order by TotalRevenue DESC
LIMIT 10;
```
### Задача P. Лидеры продаж
```
SELECT ProductName 
  FROM Sales  
 ORDER BY QuantitySold DESC LIMIT 10;
```
### Задача Q. Количество сотрудников в отделах
```
SELECT Name                                                                           DepartmentName,
       (SELECT COUNT(*) FROM Employees Where Employees.DepartmentID = Departments.ID) TotalPeople
FROM Departments;
```
### Задача R. Классификация целых чисел
```
SELECT *,
       CASE WHEN Value > 0 THEN 'positive' WHEN Value < 0 THEN 'negative' ELSE 'zero' END Classification
  FROM Numbers;
```
### Задача T. Занятые парковочные места
```
SELECT CarNumber as CarNumber,ParkingNumber as ParkingNumber from Cars t1, CarsParkings t2,ParkingPlaces t3 where t1.ID==t2.CarID and t2.ParkingID==t3.ID
```
### Задача U. Добавление поля в таблицу
```
ALTER TABLE Customers ADD COLUMN Email TEXT DEFAULT ('@mail.ru');
```
### Задача V. Добавление городов
```
INSERT INTO Cities (Town, Population) VALUES ('Vladivostok', 604901);
INSERT INTO Cities (Town) VALUES ('Novosibirsk');
INSERT INTO Cities (Town) VALUES ('Lesozavodsk');
```
### Задача W. Выборка уникальных значений
```
SELECT DISTINCT Author FROM Books;
```
### Задача X. Выборка двух полей
```
select ID, SecondName from Clients
```
### Задача Y. Выборка всех полей
```
select * from SomeTable
```
