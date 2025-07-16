CREATE DATABASE OnlineStore;
USE OnlineStore;

-- Create tables Customers, Products & Orders:
CREATE TABLE Customers(
CUSTOMER_ID INT PRIMARY KEY, 
NAME VARCHAR(50), 
EMAIL VARCHAR(50), 
PHONE BIGINT, 
ADDRESS VARCHAR(100)
);
CREATE TABLE Products(
PRODUCT_ID INT PRIMARY KEY, 
PRODUCT_NAME VARCHAR(50), 
CATEGORY VARCHAR(50), 
PRICE DECIMAL (10,2), 
STOCK INT
);
CREATE TABLE Orders(
ORDER_ID INT PRIMARY KEY, 
CUSTOMER_ID INT NOT NULL, 
PRODUCT_ID INT NOT NULL, 
QUANTITY INT, 
ORDER_DATE DATE,
FOREIGN KEY (CUSTOMER_ID) REFERENCES Customers(CUSTOMER_ID),
FOREIGN KEY (PRODUCT_ID) REFERENCES Products(PRODUCT_ID)
);

-- Insert sample data for customers
INSERT INTO Customers (CUSTOMER_ID, NAME, EMAIL, PHONE, ADDRESS) VALUES
(1, 'Amit Sharma', 'amit@example.com', 9876543210, 'Delhi'),
(2, 'Neha Verma', 'neha@example.com', 9876543211, 'Mumbai'),
(3, 'Ravi Iyer', 'ravi@example.com', 9876543212, 'Bangalore'),
(4, 'Priya Desai', 'priya@example.com', 9876543213, 'Hyderabad'),
(5, 'Ankit Mehta', 'ankit@example.com', 9876543214, 'Chennai'),
(6, 'Sneha Rao', 'sneha@example.com', 9876543215, 'Pune'); -- Will have no orders

-- Insert sample data for products
INSERT INTO Products (PRODUCT_ID, PRODUCT_NAME, CATEGORY, PRICE, STOCK) VALUES
(101, 'Laptop Pro 15', 'Electronics', 85000.00, 10),
(102, 'Wireless Mouse', 'Electronics', 1200.00, 0),          -- Out of stock
(103, 'Office Chair', 'Furniture', 7500.00, 5),
(104, 'LED Monitor', 'Electronics', 15000.00, 8),
(105, 'Bookshelf', 'Furniture', 4500.00, 2),
(106, 'Notebook Pack', 'Stationery', 300.00, 50),
(107, 'Desk Lamp', 'Electronics', 1800.00, 0);               -- Out of stock

-- Insert sample data for orders.
INSERT INTO Orders (ORDER_ID, CUSTOMER_ID, PRODUCT_ID, QUANTITY, ORDER_DATE) VALUES
(1001, 1, 101, 1, '2025-07-10'),  -- Electronics
(1002, 1, 103, 1, '2025-07-11'),  -- Furniture
(1003, 2, 104, 2, '2025-06-20'),  -- Electronics
(1004, 2, 106, 5, '2025-05-15'),  -- Stationery
(1005, 3, 103, 1, '2025-01-05'),  -- Furniture
(1006, 3, 106, 3, '2025-06-30'),  -- Stationery
(1007, 4, 105, 2, '2024-12-01'),  -- Furniture
(1008, 4, 106, 1, '2025-07-01'),  -- Stationery
(1009, 5, 101, 1, '2025-03-18'),  -- Electronics
(1010, 5, 104, 1, '2025-07-12'),  -- Electronics
(1011, 1, 106, 2, '2025-07-15');  -- Stationery

-- Order Management:
-- a) Retrieve all orders placed by a specific customer.
SELECT O.ORDER_ID, O.CUSTOMER_ID, C.NAME
FROM ORDERS O
JOIN CUSTOMERS C
ON O.CUSTOMER_ID = C.CUSTOMER_ID
WHERE O.CUSTOMER_ID = 1;

-- b) Find products that are out of stock.
SELECT PRODUCT_ID, PRODUCT_NAME, CATEGORY, PRICE
FROM Products
WHERE STOCK = 0;

-- c) Calculate the total revenue generated per product.
SELECT P.PRODUCT_ID, P.PRODUCT_NAME, SUM(O.QUANTITY * P.PRICE) AS TOTAL_REVENUE
FROM ORDERS O
JOIN PRODUCTS P
ON O.PRODUCT_ID = P.PRODUCT_ID
GROUP BY P.PRODUCT_ID, P.PRODUCT_NAME;

-- d) Retrieve the top 5 customers by total purchase amount.
SELECT C.CUSTOMER_ID, C.NAME, SUM(P.PRICE*O.QUANTITY) AS TOTAL_PURCHASE_AMOUNT
FROM ORDERS O
JOIN CUSTOMERS C ON O.CUSTOMER_ID = C.CUSTOMER_ID
JOIN PRODUCTS P ON O.PRODUCT_ID = P.PRODUCT_ID
GROUP BY C.CUSTOMER_ID, C.NAME
ORDER BY TOTAL_PURCHASE_AMOUNT DESC
LIMIT 5;

-- e) Find customers who placed orders in at least two different product categories.
SELECT C.CUSTOMER_ID, C.NAME, COUNT(DISTINCT P.CATEGORY) AS CATEGORY_COUNT
FROM ORDERS O
JOIN CUSTOMERS C ON O.CUSTOMER_ID = C.CUSTOMER_ID
JOIN PRODUCTS P ON O.PRODUCT_ID = P.PRODUCT_ID
GROUP BY C.CUSTOMER_ID, C.NAME
HAVING COUNT(DISTINCT P.CATEGORY) >= 2;

-- Analytics:
-- a) Find the month with the highest total sales.
SELECT YEAR(O.ORDER_DATE), MONTH(O.ORDER_DATE), SUM(P.PRICE*O.QUANTITY) AS TOTAL_SALES
FROM ORDERS O
JOIN PRODUCTS P ON O.PRODUCT_ID = P.PRODUCT_ID
GROUP BY YEAR(O.ORDER_DATE), MONTH(O.ORDER_DATE)
ORDER BY TOTAL_SALES DESC
LIMIT 1;

-- b) Identify products with no orders in the last 6 months.
SELECT P.PRODUCT_ID, P.PRODUCT_NAME
FROM Products P
LEFT JOIN Orders O ON P.PRODUCT_ID = O.PRODUCT_ID 
    AND O.ORDER_DATE >= CURDATE() - INTERVAL 6 MONTH
WHERE O.ORDER_ID IS NULL;

-- c) Retrieve customers who have never placed an order.
SELECT C.CUSTOMER_ID, C.NAME
FROM Customers C
LEFT JOIN Orders O ON C.CUSTOMER_ID = O.CUSTOMER_ID
WHERE O.ORDER_ID IS NULL;

-- d) Calculate the average order value across all orders.
SELECT AVG(OrderTotal) AS AVERAGE_ORDER_VALUE
FROM (
SELECT O.ORDER_ID, SUM(O.QUANTITY * P.PRICE) AS OrderTotal
FROM Orders O
JOIN Products P ON O.PRODUCT_ID = P.PRODUCT_ID
GROUP BY O.ORDER_ID
) AS OrderSums;


