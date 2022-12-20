DELIMITER /
-- процедурки 
CREATE PROCEDURE print_info(num int)
BEGIN
    SELECT * FROM `Order` WHERE ID_Order = num;
END/

CREATE PROCEDURE update_exp(num int, new_Cost int)
BEGIN
    UPDATE `Order`
    SET Cost = new_Cost
    WHERE ID_Order = num;
END/

CREATE PROCEDURE search_info(new_Salary int, src_Role VARCHAR(45))
BEGIN
    SELECT * FROM Worker
    WHERE Salary>=new_Salary AND `Role`=src_Role;
END/

-- функции

CREATE FUNCTION sum_Salary(num int, count int)
RETURNS
float DETERMINISTIC
BEGIN
    DECLARE summ int;
    SET summ = ( SELECT Salary FROM Worker
    WHERE ID_Worker = num) * count;
    RETURN(summ);
END/

CREATE FUNCTION status_app(num int)
RETURNS VARCHAR(180) DETERMINISTIC
BEGIN
    DECLARE info, info2 VARCHAR(180);
    SET info = ( SELECT `Date` FROM `Order`
    WHERE ID_Order = num);
    SET info2 = ( SELECT Expiration FROM `Order`
    WHERE ID_Order = num);
    RETURN CONCAT('Вы оформили заказ - ', info,'. Крайний срок сдачи - ',  info2);
END/

CREATE FUNCTION allowance(num int, allowance int)
RETURNS
float DETERMINISTIC
BEGIN
    DECLARE summ float;
    SET summ = (( SELECT Salary FROM Worker
    WHERE ID_Worker = num) + (( SELECT Salary FROM Worker
    WHERE ID_Worker = num) * allowance DIV 100));
    RETURN(summ);
END/

-- триггеры
CREATE TRIGGER min_Salary BEFORE UPDATE ON Worker FOR EACH ROW
BEGIN
    IF new.Salary <= 10000 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Зарплата не может ниже 10000₽';
    END IF;
END/

CREATE TRIGGER number_check BEFORE UPDATE ON Client FOR EACH ROW
BEGIN
    IF new.Number NOT LIKE'+79%'  THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Номер должен начинаться +79';
    END IF;
END/

CREATE TRIGGER Place_check BEFORE UPDATE ON Place FOR EACH ROW
BEGIN
    IF new.adress = ''  THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Отсутствует адресс';
    END IF;
END/
DELIMITER ;