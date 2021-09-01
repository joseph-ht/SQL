CREATE TABLE transactions 
(
sender int,
receiver int,
amount int,
transaction_date date
)

INSERT INTO transactions (sender, receiver, amount, transaction_date)
VALUES 
 (5,2,10,'2-12-20'),
 (1,3,15,'2-13-20'),
 (2,1,20,'2-13-20'),
 (2,3,25,'2-14-20'),
 (3,1,20,'2-15-20'),
 (3,2,15,'2-15-20'),
 (1,4,5,'2-16-20');

SELECT	sender, 
		SUM(amount) debits
FROM	transactions
GROUP BY
		sender

SELECT	receiver, 
		SUM(amount) credits
FROM	transactions
GROUP BY
		receiver

SELECT * 
FROM(
  SELECT sender, SUM(amount) debits
  FROM transactions
  GROUP BY sender
  ) A
  FULL OUTER JOIN
  (
  SELECT receiver, SUM(amount) credits
  FROM transactions
  GROUP BY receiver
  ) B
  ON A.sender=B.receiver

SELECT	COALESCE (sender, receiver) users,
		COALESCE(credits, 0) - COALESCE (debits, 0) AS net_change
FROM(
  SELECT sender, SUM(amount) debits
  FROM transactions
  GROUP BY sender
  ) A
  FULL OUTER JOIN
  (
  SELECT receiver, SUM(amount) credits
  FROM transactions
  GROUP BY receiver
  ) B
  ON A.sender=B.receiver
  ORDER BY
	net_change DESC;
