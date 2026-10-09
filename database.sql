use ecommerce_analysis;
show databases;
USE ecommerce_analysis;
select database();
USE ecommerce_analysis;

CREATE TABLE ecommerce_data (
    InvoiceNo VARCHAR(20),
    StockCode VARCHAR(20),
    Description VARCHAR(255),
    Quantity INT,
    InvoiceDate DATETIME,
    UnitPrice DECIMAL(10,2),
    CustomerID INT,
    Country VARCHAR(100),
    TotalAmount DECIMAL(12,2)
);
DESCRIBE cleaned_ecommerce_data;
SELECT COUNT(*) FROM cleaned_ecommerce_data;
SELECT *
FROM cleaned_ecommerce_data
LIMIT 10;
DESCRIBE cleaned_ecommerce_data;
SELECT COUNT(*) AS total_rows
FROM cleaned_ecommerce_data
SELECT *
FROM cleaned_ecommerce_data
LIMIT 10;

/*Q1. Check how many records you have/*

SELECT COUNT(*) AS total_rows
FROM cleaned_ecommerce_data;

DESCRIBE cleaned_ecommerce_data;

/*Q2. Find the date range (This tells us the period covered by your e-commerce data.)/*

SELECT 
    MIN(invoicedate) AS first_date,
    MAX(invoicedate) AS last_date
FROM cleaned_ecommerce_data;

/*Q3. Calculate total sales?/*
SELECT 
    ROUND(SUM(sales), 2) AS total_sales
FROM cleaned_ecommerce_data;

/*Q4. Calculate total quantity sold?/*

SELECT 
    SUM(quantity) AS total_quantity_sold
FROM cleaned_ecommerce_data;

/*Q5.Find number of unique orders? (Because the same invoice can contain multiple products, use COUNT(DISTINCT):)/*

SELECT 
    COUNT(DISTINCT invoiceno) AS total_orders
FROM cleaned_ecommerce_data;

/*Q6. Find number of customers?/*

SELECT 
    COUNT(DISTINCT customerid) AS total_customers
FROM cleaned_ecommerce_data;

/*Q7. Find number of products?/*
SELECT 
    COUNT(DISTINCT stockcode) AS total_products
FROM cleaned_ecommerce_data;

/*Q8. Find the top 10 products by sales/*
SELECT 
    description,
    ROUND(SUM(sales), 2) AS total_sales
FROM cleaned_ecommerce_data
GROUP BY description
ORDER BY total_sales DESC
LIMIT 10;

/*Q9. Country-wise sales? (This is another important analysis:)/*

SELECT 
    country,
    ROUND(SUM(sales), 2) AS total_sales
FROM cleaned_ecommerce_data
GROUP BY country
ORDER BY total_sales DESC;

/*Q10. Top 10 customers?/*

SELECT 
    customerid,
    ROUND(SUM(sales), 2) AS total_sales
FROM cleaned_ecommerce_data
WHERE customerid IS NOT NULL
GROUP BY customerid
ORDER BY total_sales DESC
LIMIT 10;

/*Q11. Monthly sales? (This is particularly useful later when you create your Power BI dashboard.)/*

SELECT 
    YEAR(invoicedate) AS year,
    MONTH(invoicedate) AS month,
    ROUND(SUM(sales), 2) AS total_sales
FROM cleaned_ecommerce_data
GROUP BY YEAR(invoicedate), MONTH(invoicedate)
ORDER BY year, month;

/*Q12. Average Order Value (AOV)? (This tells you the average amount spent per order.)/*

SELECT 
    ROUND(SUM(sales) / COUNT(DISTINCT invoiceno), 2) AS average_order_value
FROM cleaned_ecommerce_data;

/*Q13. Average product price?/*

SELECT 
    ROUND(AVG(unitprice), 2) AS average_unit_price
FROM cleaned_ecommerce_data
WHERE unitprice > 0

/*Q14. Top 10 products by quantity sold?/*

SELECT 
    description,
    SUM(quantity) AS total_quantity_sold
FROM cleaned_ecommerce_data
GROUP BY description
ORDER BY total_quantity_sold DESC
LIMIT 10;

/*Q15. Top 10 customers by number of orders(This identifies your most frequent customers)/*

SELECT 
    customerid,
    COUNT(DISTINCT invoiceno) AS total_orders
FROM cleaned_ecommerce_data
WHERE customerid IS NOT NULL
GROUP BY customerid
ORDER BY total_orders DESC
LIMIT 10;

/*Q16.Customer revenue analysis(Find customers who generated the most revenue?)/*

SELECT 
    customerid,
    COUNT(DISTINCT invoiceno) AS total_orders,
    ROUND(SUM(sales), 2) AS total_sales
FROM cleaned_ecommerce_data
WHERE customerid IS NOT NULL
GROUP BY customerid
ORDER BY total_sales DESC
LIMIT 10;

/*Q17.Country-wise number of customers(This tells you which countries have the largest customer base.)/*

SELECT 
    country,
    COUNT(DISTINCT customerid) AS total_customers
FROM cleaned_ecommerce_data
WHERE customerid IS NOT NULL
GROUP BY country
ORDER BY total_customers DESC;

/*Q18.Country-wise orders(Now you can compare customers vs orders vs sales by country.)/*

SELECT 
    country,
    COUNT(DISTINCT invoiceno) AS total_orders
FROM cleaned_ecommerce_data
GROUP BY country
ORDER BY total_orders DESC;

/*Q19. Monthly sales with number of orders(Let's make your monthly analysis more useful ***)/*

SELECT 
    YEAR(invoicedate) AS year,
    MONTH(invoicedate) AS month,
    COUNT(DISTINCT invoiceno) AS total_orders,
    ROUND(SUM(sales), 2) AS total_sales
FROM cleaned_ecommerce_data
GROUP BY YEAR(invoicedate), MONTH(invoicedate)
ORDER BY year, month;

/*Q20. Day of the week analysis(Find which days generate the most sales:)
(Which day of the week has the highest sales?)/*

SELECT 
    DAYNAME(invoicedate) AS day_of_week,
    COUNT(DISTINCT invoiceno) AS total_orders,
    ROUND(SUM(sales), 2) AS total_sales
FROM cleaned_ecommerce_data
GROUP BY DAYNAME(invoicedate), DAYOFWEEK(invoicedate)
ORDER BY DAYOFWEEK(invoicedate);

/*Q21. Hour-wise sales (Your invoicedate contains the time, so we can analyze the busiest hours.)(At what time of day are customers buying the most?
)/*

SELECT 
    HOUR(invoicedate) AS hour,
    COUNT(DISTINCT invoiceno) AS total_orders,
    ROUND(SUM(sales), 2) AS total_sales
FROM cleaned_ecommerce_data
GROUP BY HOUR(invoicedate)
ORDER BY total_sales DESC;

/*Q22. Find cancelled orders (Your dataset may contain cancelled invoices beginning with C. Check them:)(If your cleaning process removed cancelled transactions, you may get 0. That's okay.)/*

SELECT 
    COUNT(DISTINCT invoiceno) AS cancelled_orders
FROM cleaned_ecommerce_data
WHERE invoiceno LIKE 'C%';

/*Q23.Compare cancelled vs normal orders(This is a good business insight.)/*

SELECT 
    CASE 
        WHEN invoiceno LIKE 'C%' THEN 'Cancelled'
        ELSE 'Completed'
    END AS order_status,
    COUNT(DISTINCT invoiceno) AS total_orders,
    ROUND(SUM(sales), 2) AS total_sales
FROM cleaned_ecommerce_data
GROUP BY order_status;

/*Q24. Find products with negative quantity(If your cleaned dataset contains no negative quantities, that's a good validation result.)/*

SELECT 
    COUNT(*) AS negative_quantity_records
FROM cleaned_ecommerce_data
WHERE quantity < 0;

/*Q25. Find products with the highest revenue per transaction (This helps identify high-value products.)/*

SELECT 
    description,
    ROUND(SUM(sales), 2) AS total_sales,
    SUM(quantity) AS total_quantity,
    ROUND(SUM(sales) / NULLIF(SUM(quantity), 0), 2) AS revenue_per_unit
FROM cleaned_ecommerce_data
GROUP BY description
ORDER BY revenue_per_unit DESC
LIMIT 10;


/*final 1. Total revenue/*
SELECT 
    ROUND(SUM(sales), 2) AS total_sales
FROM cleaned_ecommerce_data
WHERE quantity > 0;

/*final 2. Total orders/*

SELECT 
    COUNT(DISTINCT invoiceno) AS total_orders
FROM cleaned_ecommerce_data
WHERE quantity > 0;

/*final 3. Total customers/*

SELECT 
    COUNT(DISTINCT customerid) AS total_customers
FROM cleaned_ecommerce_data
WHERE customerid IS NOT NULL
  AND quantity > 0;
  
  /*final 4. Total quantity sold?/*
  
  SELECT 
    SUM(quantity) AS total_quantity
FROM cleaned_ecommerce_data
WHERE quantity > 0;

