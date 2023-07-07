-- Show table schema 
\d+ retail;

-- Show first 10 rows
SELECT * FROM retail limit 10;

-- Check # of records
SELECT COUNT(*) FROM retail;

-- number of clients (e.g. unique client ID)
SELECT COUNT(DISTINCT(customer_id)) FROM retail;

-- invoice date range (e.g. max/min dates)
SELECT MAX(invoice_date) as MAX, MIN(invoice_date) as MIN FROM retail;

-- number of SKU/merchants (e.g. unique stock code)
SELECT COUNT(DISTINCT(stock_code)) FROM retail;

-- Calculate average invoice amount excluding invoices with a negative amount (e.g. canceled orders have negative amount)
SELECT AVG(SELECT AVG(quantity*unit_price) FROM retail GROUP BY invoice_no HAVING AVG(quantity*unit_price) > 0) FROM retail;

-- Calculate total revenue (e.g. sum of unit_price * quantity)
SELECT SUM(quantity*unit_price) FROM retail;

-- Calculate total revenue by YYYYMM
SELECT (CAST(EXTRACT(YEAR FROM invoice_date) AS INTEGER)*100 + CAST(EXTRACT(MONTH FROM invoice_date) AS INTEGER)) AS YYYYMM,
        SUM(quantity*unit_price) AS SUM
FROM retail
GROUP BY YYYYMM
ORDER BY YYYYMM ASC;



