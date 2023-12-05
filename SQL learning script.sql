SELECT *
FROM Employee;

CREATE TABLE Employee (
emp_id int PRIMARY KEY,
first_name varchar(50),
last_name varchar(50),
birth_date DATE,
sex varchar(5),
salary int,
super_id int,
branch_id int
);

CREATE TABLE Branch (
branch_id int PRIMARY KEY,
branch_name varchar(50),
mgr_id int,
mgr_start_date DATE,
FOREIGN KEY(mgr_id) REFERENCES employee(emp_id) ON DELETE SET NULL
);

ALTER TABLE Employee
ADD FOREIGN KEY(branch_id) REFERENCES Branch(branch_id) ON DELETE SET NULL;

ALTER TABLE Employee
ADD FOREIGN KEY(super_id) REFERENCES Employee(emp_id) ON DELETE SET NULL;

CREATE TABLE Client (
client_id int PRIMARY KEY,
client_name varchar(50),
branch_id int,
FOREIGN KEY (branch_id) REFERENCES Branch(branch_id) ON DELETE SET NULL
);

CREATE TABLE Works_With (
emp_id int,
client_id int,
total_sales int,
PRIMARY KEY(emp_id, client_id),
FOREIGN KEY(emp_id) REFERENCES Employee(emp_id) ON DELETE CASCADE,
FOREIGN KEY(client_id) REFERENCES Client(client_id) ON DELETE CASCADE
);

CREATE TABLE Branch_Supplier (
branch_id int,
supplier_name varchar(50),
supply_type varchar(50),
PRIMARY KEY(branch_id, supplier_name),
FOREIGN KEY(branch_id) REFERENCES Branch(branch_id) ON DELETE CASCADE
);

-- INSERTING INFORMATION --
-- CORPORATE

INSERT INTO Employee VALUES
(100, 'David', 'Wallace', '1967-11-17', 'M', 250000, NULL, NULL);

INSERT INTO Branch VALUES
(1, 'Corporate', 100, '2006-02-09');

UPDATE Employee
SET branch_id = 1
WHERE emp_id = 100;

INSERT INTO Employee VALUES
(101, 'Jan', 'Levinson', '1961-05-11', 'F', 110000, 100, 1); 

-- Scranton

INSERT INTO Employee VALUES
(102, 'Michael', 'Scott', '1964-03-15', 'M', '75000', 100, NULL);

INSERT INTO Branch VALUES
(2, 'Scranton', 102, '1992-04-06');

UPDATE Employee
SET branch_id = 2
WHERE emp_id = 102;

INSERT INTO Employee VALUES (103, 'Angela', 'Martin', '1971-06-25', 'F', 63000, 102, 2);
INSERT INTO Employee VALUES (104, 'Kelly', 'Kapoor', '1980-02-05', 'F', 55000, 102,2);
INSERT INTO Employee VALUES (105, 'Stanley', 'Hudson', '1958-02-19', 'M', 69000, 102, 2);

-- Stamford

INSERT INTO Employee VALUES
(106, 'Josh',  'Porter', '1969-09-05', 'M', 78000, 100, NULL);

INSERT INTO Branch VALUES
(3, 'Stamford', 106, '1998-02-13');

UPDATE Employee
SET branch_id = 3
WHERE emp_id = 106;

INSERT INTO Employee VALUES (107, 'Andy', 'Bernard', '1973-07-22', 'M', 65000, 106, 3);
INSERT INTO Employee VALUES (108, 'Jim', 'Halpert', '1978-10-01', 'M', 71000, 106, 3);

-- BRANCH SUPPPLIER

INSERT INTO Branch_Supplier VALUES 
(2, 'Hammer Mill', 'Paper'),
(3, 'Uni-ball', 'Writing Utensils'),
(3, 'Patriot Paper', 'Paper'),
(2, 'J.T. Forms & Labels', 'Custom Forms');

UPDATE Branch_Supplier
SET branch_id = 2
WHERE supplier_name = 'Uni-ball';

INSERT INTO Branch_Supplier VALUES
(3, 'Uni-ball', 'Writing Utensils'),
(3, 'Hammer Mill', 'Paper'),
(3, 'Stamford Lables', 'Custom Forms');

-- CLIENT

INSERT INTO Client VALUES
(400, 'Dunmore Highschool', 2),
(401, 'Lackawana Country', 2),
(402, 'FedEx', 3),
(403, 'John Daly Law, LLC', 3),
(404, 'Scranton Whitepages', 2),
(405, 'Times Newspaper', 3),
(406, 'FedEx', 2);

-- WORKS WITH

INSERT INTO Works_With VALUES
(105, 400, 55000),
(102, 401, 267000),
(108, 402, 22500),
(107, 403, 5000),
(108, 403, 12000),
(105, 404, 33000),
(107, 405, 26000),
(102, 406, 15000),
(105, 406, 130000);


-- Finding information --

-- Find the forename and surnames names of all employees

SELECT first_name AS forename, last_name AS surname
FROM Employee;

-- Find out all the different genders / branch_ids

SELECT DISTINCT sex
FROM Employee;

SELECT DISTINCT branch_id
FROM Employee;

-- Find the number of employees / number of supervisors

SELECT COUNT(emp_id)
FROM Employee;

SELECT COUNT(super_id)
FROM Employee;

-- Find the number of female employees born after 1970

SELECT COUNT(emp_id)
FROM Employee
WHERE sex = 'F' AND birth_date > '1970-01-01';

-- Find the average of employee's salary who are male

SELECT AVG(Salary)
FROM Employee
WHERE sex = 'M';

-- Find the sum of all employee's salaries

SELECT SUM(Salary)
FROM Employee;

-- Find out how many males and females there are

SELECT COUNT(sex), sex
FROM Employee
GROUP BY sex;

-- Find the total sales of each salesman

SELECT SUM(total_sales), emp_id
FROM Works_With
GROUP BY emp_id;

-- Find the how much money each client spent with the branch

SELECT SUM(total_sales), client_id
FROM Works_With
GROUP BY client_id;


-- % = any # characters, _ = one character --

-- Find any client's who are an LLC

SELECT *
FROM Client
WHERE client_name LIKE '%LLC';

-- Find any branch suppliers who are in the label business

SELECT *
FROM Branch_Supplier
WHERE supplier_name LIKE '%Label%';

-- Find any employee born in October

SELECT *
FROM Employee
WHERE birth_date LIKE '____-10-__';

-- Find any employees vorn in February

SELECT *
FROM Employee
WHERE birth_date LIKE '____-02%';

-- Find any clients who are schools

SELECT *
FROM Client
WHERE client_name LIKE '%school%';


-- UNION --
-- Find a list of employee and branch names

SELECT first_name AS Company_Names
FROM Employee
UNION
SELECT branch_name
FROM Branch;

-- Find a list of all clients & branch suppliers' names & id

SELECT client_name, client.branch_id
FROM Client
UNION
SELECT supplier_name, Branch_supplier.branch_id
FROM Branch_Supplier;

-- Find a list of all total money spent or earned by the company

SELECT SUM(salary)
FROM Employee
UNION
SELECT SUM(total_sales)
FROM Works_With;


-- JOINS - JOIN, LEFT JOIN, RIGHT JOIN --

INSERT INTO Branch VALUES (4, 'Buffalo', NULL, NULL);

SELECT *
FROM Branch;

-- Find all branches and the names of their managers

SELECT Employee.emp_id, Employee.first_name, Branch.branch_name
FROM Employee
JOIN Branch
ON Employee.emp_id = Branch.mgr_id;

SELECT Employee.emp_id, Employee.first_name, Branch.branch_name
FROM Employee
RIGHT JOIN Branch
ON Employee.emp_id = Branch.mgr_id;


-- NESTED QUERIES --
-- Find names of all employees who have sold over 30,000 to a single client

SELECT Employee.first_name, Employee.last_name
FROM Employee
WHERE Employee.emp_id IN (
SELECT Works_With.emp_id
FROM Works_With
WHERE Works_With.total_sales > 30000
);

-- Find all clients who are handles by the branch that Michael Scott manages (Assume you know Michael's ID)

SELECT client.client_name
FROM Client
WHERE Client.branch_id = (
SELECT Branch.branch_id
FROM Branch
WHERE Branch.mgr_id = 102
LIMIT 1
);
-- LIMIT 1 to select only 1 in case 'Michael' is managing more than 1 branch, then use IN

-- ON DELETE SET NULL (If delete, the Foreign Key row is set to NULL) / ON DELETE CASCADE (If delete, the foreign key row will also be deleted)

CREATE TABLE Branch (
branch_id int PRIMARY KEY,
branch_name varchar(50),
mgr_id int,
mgr_start_date DATE,
FOREIGN KEY(mgr_id) REFERENCES employee(emp_id) ON DELETE SET NULL
);

CREATE TABLE Branch_Supplier (
branch_id int,
supplier_name varchar(50),
supply_type varchar(50),
PRIMARY KEY(branch_id, supplier_name),
FOREIGN KEY(branch_id) REFERENCES Branch(branch_id) ON DELETE CASCADE
);

-- If Primacy Key (Set DELETE CASCADE), if Foreign Key (Can DELETE SET NULL)


-- CREATE TRIGGER TABLE -- TRIGGER (BEFORE / AFTER // INSERT / DELETE / UPDATE )
-- To be used in terminal: Open 'Command Line' separate App to run DELIMITER

CREATE TABLE trigger_test(
message varchar(100)
);

DELIMITER $$
CREATE
	TRIGGER my_trigger BEFORE INSERT
    ON Employee
    FOR EACH ROW BEGIN
    INSERT INTO trigger_test VALUES('added new employee');
    END$$
DELIMITER;

INSERT INTO Employee VALUES (109, 'Oscar', 'Martinez', '1968-02-19', 'M', 69000, 106, 3);

SELECT * FROM trigger_test;

-- ANOTHER EXAMPLE OF TRIGGER TEST --

DELIMITER $$
CREATE
	TRIGGER my_trigger1 BEFORE INSERT
    ON Employee
    FOR EACH ROW BEGIN
    INSERT INTO trigger_test VALUES(NEW.first_name);
    END $$
DELIMITER;

INSERT INTO Employee VALUES (110, 'Kevin', 'Malone', '1978-02-19', 'M', 69000, 106, 3);

SELECT * FROM trigger_test;


-- TRIGGER WITH 'ELSEIF' / 'ELSE' --

DELIMITER $$
CREATE
	TRIGGER my_trigger2 BEFORE INSERT
    ON Employee
    FOR EACH ROW BEGIN
		IF NEW.sex = 'M' THEN
			INSERT INTO trigger_test VALUES ('added male employee');
		ELSEIF NEW.sex = 'F' THEN
			INSERT INTO trigger_test VALUES ('added female');
        ELSE
			INSERT INTO trigger_test VALUES ('added other employee');
        END IF;
	END$$
DELIMITER;

INSERT INTO Employee VALUES (111, 'Pam', 'Beesly', '1988-02-19', 'F', 69000, 106, 3);

SELECT * FROM trigger_test;