USE SAKILA;
SHOW TABLES;

#STEP 1: Create a View
#First, create a view that summarizes rental information for each customer. 
#The view should include the customer's ID, name, email address, and total number of rentals (rental_count).

CREATE VIEW customer_rental_summary AS
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM
    customer c
INNER JOIN rental r ON c.customer_id = r.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email;
    
    SELECT * FROM customer_rental_summary;
    
#Step 2: Create a Temporary Table
#Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
#The Temporary Table should use the rental summary view created in Step 1 to join with the payment table 
#and calculate the total amount paid by each customer.  

USE sakila;

CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT 
    crs.customer_id, 
    crs.first_name, 
    crs.last_name, 
    crs.email, 
    crs.rental_count, 
    SUM(p.amount) AS total_paid
FROM 
    customer_rental_summary crs
INNER JOIN payment p 
    ON crs.customer_id = p.customer_id
GROUP BY 
    crs.customer_id, crs.first_name, crs.last_name, crs.email, crs.rental_count;
  
  SELECT * FROM customer_payment_summary;
  
#Step 3: Create a CTE and the Customer Summary Report
WITH customer_summary AS (
    SELECT
        crs.first_name,
        crs.last_name,
        crs.email,
        crs.rental_count,
        cps.total_paid,
        cps.total_paid / crs.rental_count AS average_payment_per_rental
    FROM
        customer_rental_summary crs
    JOIN customer_payment_summary cps ON crs.customer_id = cps.customer_id
)
SELECT
    first_name,
    last_name,
    email,
    rental_count,
    total_paid,
    average_payment_per_rental
FROM
    customer_summary;