-- 04_credit_utilization_analysis.sql
-- Analysis cutoff date: 2026-11-19

-- Task 06 - Credit limit by customer
SELECT c.customer_name, SUM(cc.credit_limit) AS total_credit_limit FROM customers c JOIN credit_cards cc USING(customer_id) GROUP BY c.customer_id, c.customer_name ORDER BY total_credit_limit DESC;

-- Task 07 - Statement exposure by card
SELECT cc.card_id, c.customer_name, cc.card_type, cc.credit_limit, COALESCE(SUM(s.statement_amount),0) AS total_billed FROM credit_cards cc JOIN customers c USING(customer_id) LEFT JOIN statements s USING(card_id) GROUP BY cc.card_id, c.customer_name, cc.card_type, cc.credit_limit ORDER BY total_billed DESC;

-- Task 08 - Customer billed amount
SELECT c.customer_name, COALESCE(SUM(s.statement_amount),0) AS total_billed FROM customers c LEFT JOIN credit_cards cc USING(customer_id) LEFT JOIN statements s USING(card_id) GROUP BY c.customer_id, c.customer_name ORDER BY total_billed DESC;

-- Task 09 - Utilization proxy by card
SELECT cc.card_id, c.customer_name, cc.credit_limit, COALESCE(SUM(s.statement_amount),0) AS billed_amount, ROUND(100.0*COALESCE(SUM(s.statement_amount),0)/NULLIF(cc.credit_limit,0),2) AS billed_to_limit_pct FROM credit_cards cc JOIN customers c USING(customer_id) LEFT JOIN statements s USING(card_id) GROUP BY cc.card_id, c.customer_name, cc.credit_limit ORDER BY billed_to_limit_pct DESC;

-- Task 10 - High billed-to-limit cards
SELECT * FROM (SELECT cc.card_id, c.customer_name, cc.credit_limit, COALESCE(SUM(s.statement_amount),0) AS billed, ROUND(100.0*COALESCE(SUM(s.statement_amount),0)/NULLIF(cc.credit_limit,0),2) AS pct FROM credit_cards cc JOIN customers c USING(customer_id) LEFT JOIN statements s USING(card_id) GROUP BY cc.card_id) WHERE pct >= 50 ORDER BY pct DESC;

