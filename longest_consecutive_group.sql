CREATE TABLE Employee.dbo.cricket (
  Team VARCHAR(10) NULL,
  Winning_Date DATE NULL,
  result VARCHAR(10) NULL
);

-- Drop Table EMPLOYEE.dbo.cricket;


INSERT INTO Employee.dbo.cricket (Team, Winning_Date, result) VALUES ('Team1','2023-01-01','W');
INSERT INTO Employee.dbo.cricket (Team, Winning_Date, result) VALUES('Team1','2023-02-01', 'W');
INSERT INTO Employee.dbo.cricket (Team, Winning_Date, result) VALUES('Team1','2023-03-01','L');
INSERT INTO Employee.dbo.cricket (Team, Winning_Date, result) VALUES('Team1','2023-04-01','W');
INSERT INTO Employee.dbo.cricket (Team, Winning_Date, result) VALUES('Team1','2023-05-01','L');
INSERT INTO Employee.dbo.cricket (Team, Winning_Date, result) VALUES('Team1','2023-06-01','L');
INSERT INTO Employee.dbo.cricket (Team, Winning_Date, result) VALUES('Team1','2023-07-01','W');
INSERT INTO Employee.dbo.cricket (Team, Winning_Date, result) VALUES('Team1','2023-08-01','W');
INSERT INTO Employee.dbo.cricket (Team, Winning_Date, result) VALUES('Team1','2023-09-01','W');

INSERT INTO Employee.dbo.cricket (Team, Winning_Date, result) VALUES('Team2','2023-01-01','L');
INSERT INTO Employee.dbo.cricket (Team, Winning_Date, result) VALUES('Team2','2023-02-01','W');
INSERT INTO Employee.dbo.cricket (Team, Winning_Date, result) VALUES('Team2','2023-03-01','L');
INSERT INTO Employee.dbo.cricket (Team, Winning_Date, result) VALUES('Team2','2023-04-01','W');
INSERT INTO Employee.dbo.cricket (Team, Winning_Date, result) VALUES('Team2','2023-05-01','L');
INSERT INTO Employee.dbo.cricket (Team, Winning_Date, result) VALUES('Team2','2023-06-01','L');

INSERT INTO Employee.dbo.cricket (Team, Winning_Date, result) VALUES('Team3','2023-01-01','W');
INSERT INTO Employee.dbo.cricket (Team, Winning_Date, result) VALUES('Team3','2023-02-01','W');
INSERT INTO Employee.dbo.cricket (Team, Winning_Date, result) VALUES('Team3','2023-03-01','L');
INSERT INTO Employee.dbo.cricket (Team, Winning_Date, result) VALUES('Team3','2023-04-01','W');

SELECT * FROM EMPLOYEE.dbo.cricket;

-- Find the Maximum consecutive Win for each team.
-- Show Team | consecutive_winning_count


With cte as (
SELECT *,
CASE 
  When LAG(result, 1) OVER (PARTITION BY Team ORDER BY Winning_Date) = 'L' AND result='W' then 1
  When LaG(result, 1) OVER (PARTITION BY Team ORDER BY Winning_Date) is NULL AND result='W' then 1
  else 0
END flag
FROM Employee.dbo.cricket
),
cte2 AS (
  SELECT *,
    SUM(flag) OVER (PARTITION BY Team ORDER BY Winning_Date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS s
  FROM cte
),
cte3 AS (
SELECT s, Team, COUNT(*) AS win_count
FROM cte2
WHERE result <> 'L'  --not equal sign
GROUP BY s, Team
-- ORDER BY  s, Team
)

SELECT Team, MAX(win_count) as consecutive_winning_count
FROM cte3
GROUP BY Team;
