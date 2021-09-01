--1. Find the customers who placed at least two orders per year.**

SELECT A.customer_id, A.first_name, A.last_name, YEAR(B.order_date) AS ORDER_YEAR, COUNT (B.order_id) AS NUMBER_F_ORDER
FROM sales.customers AS A, sales.orders AS B
WHERE A.customer_id = B.customer_id
GROUP BY A.customer_id, A.first_name, A.last_name, YEAR(B.order_date)
HAVING COUNT(B.order_id) >= 2
ORDER BY A.customer_id

--2. Find the total amount of each order which are placed in 2018. Then categorize them according to limits stated below.(You can use case when statements here)
--If the total amount of order    
    --less then 500 then "very low"
    --between 500 - 1000 then "low"
    --between 1000 - 5000 then "medium"
    --between 5000 - 10000 then "high"
    --more then 10000 then "very high

SELECT A.order_id, SUM(B.quantity*B.list_price) AS TOTAL_AMOUNT,
    CASE 
        WHEN SUM(B.quantity*B.list_price) < 500 THEN 'very low'
        WHEN SUM(B.quantity*B.list_price) BETWEEN 500 AND 1000 THEN 'low'
        WHEN SUM(B.quantity*B.list_price) BETWEEN 1000 AND 5000 THEN 'medium'
        WHEN SUM(B.quantity*B.list_price) BETWEEN 5000 AND 10000 THEN 'high'
        WHEN SUM(B.quantity*B.list_price) > 10000 THEN 'very high'
    END AS ORDERS
FROM sales.orders AS A
INNER JOIN sales.order_items AS B
ON A.order_id = B.order_id
WHERE YEAR(A.order_date)=2018
GROUP BY A.order_id
ORDER BY A.order_id

--3. By using Exists Statement find all customers who have placed more than two orders.

SELECT A.customer_id, A.first_name, A.last_name
FROM sales.customers AS A, sales.orders AS B
WHERE A.customer_id = B.customer_id
--GROUP BY A.customer_id
ORDER BY A.customer_id

--4. Show all the products and their list price, that were sold with more than two units in a sales order.

SELECT product_id, product_name, list_price
FROM production.products AS A
WHERE product_id IN
    (SELECT product_id
    FROM sales.order_items
    WHERE quantity >= 2)
ORDER BY product_id

--This is not working!
SELECT DISTINCT A.product_id, A.product_name, A.list_price, B.quantity
FROM production.products AS A
INNER JOIN sales.order_items AS B
ON A.product_id=B.product_id
WHERE B.quantity >= 2

--6. Find the products whose list prices are more than the average list price of products of all brands
SELECT product_id, product_name
FROM production.products
WHERE list_price > ALL (
        SELECT AVG (list_price)
        FROM production.products
        GROUP BY brand_id)