DROP DATABASE IF EXISTS mydb;
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8;

USE `mydb`;

CREATE TABLE IF NOT EXISTS `Client` (
  `ID_client` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NOT NULL,
  `Number` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`ID_client`),
  UNIQUE INDEX `Name_UNIQUE` (`Name`) VISIBLE,
  UNIQUE INDEX `Number_UNIQUE` (`Number`) VISIBLE
);
DESCRIBE  Client;
INSERT INTO Client(`Name`, `Number`) VALUES
('Чумиков Дмитрий Александрович','+79219292922'),
('Павлов Генадий Сергеевич','+79219292921'),
('Чалов Пётр Фёдорович','+79219292923'),
('Куликов Арсений Семёнович','+79219292924'),
('Воров Кирилл Алексеевич','+79219292925'),
('Дуров Василий Евгеньевич','+79219292926'),
('Цукатов Николай Дмитриевич','+79219292927');

CREATE TABLE IF NOT EXISTS `Place` (
  `ID_place` INT NOT NULL AUTO_INCREMENT,
  `adress` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`ID_place`),
  UNIQUE INDEX `adress_UNIQUE` (`adress`) VISIBLE
);
DESCRIBE  Place;
INSERT INTO Place(adress) VALUES
('бульвар Гоголя'),
('Балканская'),
('Ленина'),
('проезд Космонавтов'),
('проезд Косиора'),
('проезд Пушкина'),
('бульвар 1905 года');

CREATE TABLE IF NOT EXISTS `Worker` (
  `ID_Worker` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NOT NULL,
  `Salary` INT NOT NULL,
  `Role` VARCHAR(45) NOT NULL,
  `Place_ID_place` INT NOT NULL,
  PRIMARY KEY (`ID_Worker`, `Place_ID_place`),
  FOREIGN KEY (`Place_ID_place`) REFERENCES `Place` (`ID_place`) ON DELETE NO ACTION ON UPDATE NO ACTION
);
DESCRIBE  Worker;
INSERT INTO Worker(`Name`, Salary, `Role`, Place_ID_place) VALUES
('Павлов Генадий Сергеевич','25000','tailor',2),
('Чалов Пётр Фёдорович','25000','tailor',3),
('Куликов Арсений Семёнович','26000','tailor',4),
('Воров Кирилл Алексеевич','25000','tailor',5),
('Новикова Алёна Ильинична','40000','manager',1),
('Куплинов Василий Евгеньевич','26000','tailor',6),
('Цукатов Николай Дмитриевич','26000','tailor',7);

CREATE TABLE IF NOT EXISTS `Order` (
  `ID_Order` INT NOT NULL AUTO_INCREMENT,
  `Date` DATETIME NOT NULL,
  `Cost` INT NOT NULL,
  `Expiration` DATETIME NOT NULL,
  `Client_ID_client` INT NOT NULL,
  `Worker_ID_Worker` INT NOT NULL,
  PRIMARY KEY (`ID_Order`, `Worker_ID_Worker`, `Client_ID_client`),
    FOREIGN KEY (`Client_ID_client`) REFERENCES `Client` (`ID_client`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (`Worker_ID_Worker`) REFERENCES `Worker` (`ID_Worker`) ON DELETE NO ACTION ON UPDATE NO ACTION);
DESCRIBE `Order`;
INSERT INTO `Order` (`Date`, Cost, Expiration, Client_ID_client, Worker_ID_Worker) VALUES
('19-10-22','3000','19-11-22',2,2),
('15-10-22','4000','15-11-22',3,2),
('15-12-22','5660','15-12-22',4,3),
('15-11-22','9000','15-12-22',5,4),
('16-10-22','7000','16-11-22',7,5),
('17-10-22','4500','17-11-22',6,6),
('18-10-22','2500','18-11-22',1,7);

CREATE TABLE IF NOT EXISTS `Product` (
  `ID_Prodcut` INT NOT NULL AUTO_INCREMENT,
  `material` VARCHAR(45) NOT NULL,
  `Order_ID_Order` INT NOT NULL,
  `Order_Worker_ID_Worker` INT NOT NULL,
  `Order_Client_ID_client` INT NOT NULL,
  PRIMARY KEY (`ID_Prodcut`),
  FOREIGN KEY (`Order_ID_Order` , `Order_Worker_ID_Worker` , `Order_Client_ID_client`) REFERENCES `Order` (`ID_Order` , `Worker_ID_Worker` , `Client_ID_client`) ON DELETE NO ACTION ON UPDATE NO ACTION);
DESCRIBE `Product`;
INSERT INTO `Product` (material, Order_ID_Order, Order_Worker_ID_Worker, Order_Client_ID_client) VALUES
('cotton',1,2,2),
('fief',2,2,3),
('silk',3,3,4),
('cotton',4,4,5),
('wool',5,5,7),
('fief',6,6,6),
('silk',7,7,1);

SELECT * FROM `Product`;
SELECT * FROM `Order` WHERE Cost=9000;
SELECT * FROM `Order` WHERE Cost>4000;
SELECT * FROM `Order` WHERE Cost<7000;
SELECT * FROM `Order` WHERE Cost>=4000;
SELECT * FROM `Order` WHERE Cost<=7000;
SELECT * FROM `Order` WHERE Cost!=9000;
SELECT * FROM `Order` WHERE Cost IN (4000, 7000);
SELECT * FROM `Order` WHERE Cost BETWEEN 4000 AND 7000;
SELECT * FROM `Order` WHERE Cost NOT IN (4000, 7000);
SELECT * FROM Worker WHERE `Name` NOT LIKE ('Ку%');
SELECT * FROM Worker WHERE `Name` LIKE ('Ку%');

SELECT * FROM `Order` WHERE ID_Order = 1;
UPDATE `Order` SET Cost = 25000  WHERE ID_Order = 1;
SELECT * FROM `Order` WHERE ID_Order = 1;

SELECT ID_Order, Cost, ID_Worker
FROM `Order`
INNER JOIN Worker --Соединяет две разные таблицы, по значению ниже
ON `Order`.Cost = Worker.Salary;

SELECT * FROM `Order`;
DELETE FROM `Order` WHERE ID_employee = 7;
SELECT * FROM `Order`;

SELECT `Name` FROM (SELECT * FROM Worker WHERE `Name` LIKE ('Ку%')) AS Sort
WHERE Salary > 25000;
--вызов информации о заказе
CALL print_info(1);
DROP PROCEDURE print_info;
-- обновление
CALL update_exp(1, 5000);
SELECT * FROM `Order`;
DROP PROCEDURE update_exp;
-- поиск
CALL search_info(40000, 'manager');
SELECT * FROM Worker;
DROP PROCEDURE search_info;

-- функции
SELECT sum_Salary(2,3) FROM Worker ORDER BY ID_Worker LIMIT 1;
DROP FUNCTION sum_Salary;

--дедлайны
SELECT status_app(2) FROM `Order` ORDER BY ID_Order LIMIT 1;
DROP FUNCTION status_app;

--надбавка
SELECT allowance(1,20) FROM Worker ORDER BY ID_Worker LIMIT 1;
DROP FUNCTION allowance;

-- триггеры
UPDATE Worker
SET Salary = 1
WHERE ID_Worker = 1;
DROP TRIGGER min_Salary;

--проверка номера
UPDATE Client
SET `Number` = '43'
WHERE ID_client = 1;
DROP TRIGGER number_check;

--проверка адресса
UPDATE Place
SET adress = ''
WHERE ID_place = 1;
DROP TRIGGER company_name_check;

-- SELECT * FROM `architectural company`;
-- SELECT * FROM `Order` WHERE experience=1;
-- SELECT * FROM `Order` WHERE experience>3;
-- SELECT * FROM `Order` WHERE experience<4;
-- SELECT * FROM `Order` WHERE experience>=5;
-- SELECT * FROM `Order` WHERE experience<=5;
-- SELECT * FROM `Order` WHERE experience!=1;
-- SELECT * FROM `Order` WHERE experience IS NOT NULL;
-- SELECT * FROM `Order` WHERE experience IS NULL;
-- SELECT * FROM `Order` WHERE experience BETWEEN 1 AND 3;
-- SELECT * FROM `Order` WHERE experience IN (1, 3);
-- SELECT * FROM `Order` WHERE experience NOT IN (1, 3);
-- SELECT * FROM `Order` WHERE FIO LIKE ('Ика%');
-- SELECT * FROM `Order` WHERE FIO NOT LIKE ('Ика%');
-- SELECT * FROM customer WHERE ID_customer = 1;
-- UPDATE customer SET budget = 9000  WHERE ID_customer = 1;
-- SELECT * FROM customer WHERE ID_customer = 1;