USE master
GO

CREATE DATABASE Assignment_2
GO

CREATE TABLE [users]
(
    [User_id] VARCHAR (50),
    [Action] VARCHAR (50),
    [date] DATE
)

INSERT INTO [users]
VALUES 
(1,'start','01-01-20'), 
(1,'cancel','01-02-20'), 
(2,'start', '01-03-20'), 
(2,'publish', '01-04-20'), 
(3,'start', '01-05-20'), 
(3,'cancel', '01-06-20'), 
(1,'start', '01-07-20'), 
(1,'publish', '01-08-20');

-- Retrieve count of starts, cancels, and publishes for each user,

WITH A AS (
    SELECT User_id, 
    SUM(CASE WHEN Action = 'start' THEN 1 ELSE 0 END) AS starts, 
    SUM(CASE WHEN Action = 'cancel' THEN 1 ELSE 0 END) AS cancels, 
    SUM(CASE WHEN Action = 'publish' THEN 1 ELSE 0 END) AS publishes
    FROM [users]
    GROUP BY User_id 
)

-- Calculate publication, cancelation rate for each user by dividing by number of starts, casting as float by multiplying by 1.0

SELECT User_id, 
    1.0*publishes/starts AS publish_rate,
    1.0*cancels/starts AS cancel_rate
FROM A;