
-- # CoderPad provides a basic SQL sandbox with the following schema.
-- # You can also use commands like '\dt;' and '\d employees;'

-- # employees                             projects
-- # +---------------+---------+           +---------------+---------+
-- # | id            | int     |<----+  +->| id            | int     |
-- # | first_name    | varchar |     |  |  | title         | varchar |
-- # | last_name     | varchar |     |  |  | start_date    | date    |
-- # | salary        | int     |     |  |  | end_date      | date    |
-- # | department_id | int     |--+  |  |  | budget        | int     |
-- # +---------------+---------+  |  |  |  +---------------+---------+
-- #                              |  |  |
-- # departments                  |  |  |  employees_projects
-- # +---------------+---------+  |  |  |  +---------------+---------+
-- # | id            | int     |<-+  |  +--| project_id    | int     |
-- # | name          | varchar |     +-----| employee_id   | int     |
-- # +---------------+---------+           +---------------+---------+
-- # */

-- department_name and average salary of employee in that department


-- each department show highest salary employee details (first_name)


-- Employee details

CREATE TABLE EMPLOYEE.dbo.Employee
(
    id INT,
    first_name VARCHAR(30),
    last_name VARCHAR(30),
    salary INT,
    department_id INT
)
INSERT INTO EMPLOYEE.dbo.Employee
    (id, first_name, last_name, salary, department_id)
VALUES
    (1, 'John', 'Smith', 20000, 1),
    (2, 'Ava', 'Muffin', 10000, 5),
    (3, 'Cailin', 'Ninson', 30000, 2),
    (4, 'Mike', 'Peterson', 20000, 2),
    (5, 'Ian', 'Peterson', 80000, 2),
    (6, 'John', 'Mills', 50000, 3),
    (7, 'Johan', 'Millego', 60000, 3)
SELECT *
FROM EMPLOYEE.dbo.Employee;

-- Departments details
CREATE TABLE EMPLOYEE.dbo.Departments
(
    id INT,
    name VARCHAR(20)
)
INSERT INTO EMPLOYEE.dbo.Departments
    (id, name)
VALUES
    (1, 'Reporting'),
    (2, 'Engineering'),
    (3, 'Marketing'),
    (4, 'Biz Dev'),
    (5, 'Silly Walks')

SELECT *
FROM EMPLOYEE.dbo.Departments;

-- Projects Data
CREATE TABLE EMPLOYEE.dbo.Projects
(
    id INT,
    title VARCHAR(50),
    start_date DATETIME,
    end_date DATETIME,
    budget INT
)
INSERT INTO EMPLOYEE.dbo.Projects
    (id, title, start_date, end_date, budget)
VALUES
    (1, 'Build a Cool Site', '2011-10-28', '2012-01-26', 1000000),
    (2, 'Update TPS Reports', '2011-07-20', '2011-10-28', 100000),
    (3, 'Design 3 New Silly Walks', '2009-05-11', '2009-12-19', 100)


SELECT *
FROM EMPLOYEE.dbo.Projects;

-- Employee_projects data
CREATE TABLE EMPLOYEE.dbo.Employee_projects
(
    project_id INT,
    employee_id INT
)
INSERT INTO EMPLOYEE.dbo.Employee_projects
    (project_id, employee_id)
VALUES
    (2, 1),
    (3, 2),
    (1, 2),
    (2, 2),
    (1, 3),
    (1, 4),
    (1, 5),
    (1, 1)


SELECT *
FROM EMPLOYEE.dbo.Employee_projects;


-- Queries
-- 1. department_name and average salary of employee in that department
SELECT d.name, AVG(e.salary) avg_salary
FROM EMPLOYEE.dbo.Employee as e
JOIN Employee.dbo.Departments as d
ON e.department_id = d.id
GROUP BY d.name;

-- 2. each department show highest salary employee details (first_name)
WITH MaxSalaries AS (
    SELECT department_id, MAX(salary) AS max_salary
    FROM EMPLOYEE.dbo.Employee
    GROUP BY department_id
)

SELECT e.first_name, e.last_name, e.salary, d.name
FROM EMPLOYEE.dbo.Employee e
JOIN EMPLOYEE.dbo.Departments d
ON e.department_id = d.id
JOIN MaxSalaries ms
ON ms.department_id = d.id AND e.salary = ms.max_salary

-- 3. List all employees working on more than one project
WITH CTE AS (
    SELECT employee_id, COUNT(project_id) as project_count
    FROM EMPLOYEE.dbo.Employee_projects
    GROUP BY employee_id
)
SELECT *
FROM EMPLOYEE.dbo.Employee e
JOIN CTE c
ON e.id = c.employee_id
WHERE c.project_count>1;

-- OR

SELECT e.id, e.first_name, e.last_name, COUNT(ep.project_id) AS project_count
FROM EMPLOYEE.dbo.Employee e
JOIN EMPLOYEE.dbo.Employee_projects ep ON e.id = ep.employee_id
GROUP BY e.id, e.first_name, e.last_name
HAVING COUNT(ep.project_id) > 1;

-- 4. 📅 Find projects that lasted more than 6 months
SELECT * FROM EMPLOYEE.dbo.Projects;
SELECT *
FROM EMPLOYEE.dbo.Projects
WHERE DATEADD(MONTH, 6, start_date) < end_date;

-- 5. 🧑‍💻 Find employees not assigned to any project
SELECT e.first_name, e.last_name, e.salary
FROM EMPLOYEE.dbo.Employee_projects as ep
RIGHT JOIN EMPLOYEE.dbo.Employee as e
ON ep.employee_id = e.id
WHERE ep.project_id is NULL


-- 6. 🧮 Count of employees per project show project_title and employee count
SELECT p.id, p.title, count(ep.employee_id) as total_employees
FROM EMPLOYEE.dbo.Projects as p
JOIN EMPLOYEE.dbo.Employee_projects as ep
ON p.id = ep.project_id
GROUP BY p.id, p.title
