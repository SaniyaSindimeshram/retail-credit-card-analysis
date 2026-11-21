-- 05_payment_behaviour_analysis.sql
-- Analysis cutoff date: 2026-11-19

-- Task 11 - Total completed payments
SELECT SUM(payment_amount) AS completed_payments FROM payments WHERE payment_status='Completed';

-- Task 12 - Payment status distribution
SELECT payment_status, COUNT(*) AS payment_count, SUM(payment_amount) AS amount FROM payments GROUP BY payment_status ORDER BY payment_status;

-- Task 13 - Payments per statement
SELECT s.statement_id, s.statement_amount, COALESCE(SUM(CASE WHEN p.payment_status='Completed' THEN p.payment_amount ELSE 0 END),0) AS amount_paid FROM statements s LEFT JOIN payments p USING(statement_id) GROUP BY s.statement_id ORDER BY s.statement_id;

-- Task 14 - Collection percentage by statement
SELECT s.statement_id, s.statement_amount, COALESCE(SUM(CASE WHEN p.payment_status='Completed' THEN p.payment_amount ELSE 0 END),0) AS paid, ROUND(100.0*COALESCE(SUM(CASE WHEN p.payment_status='Completed' THEN p.payment_amount ELSE 0 END),0)/NULLIF(s.statement_amount,0),2) AS collection_pct FROM statements s LEFT JOIN payments p USING(statement_id) GROUP BY s.statement_id ORDER BY collection_pct;

-- Task 15 - Customer payment behaviour
SELECT c.customer_name, SUM(s.statement_amount) AS billed, SUM(COALESCE(x.paid,0)) AS paid, ROUND(100.0*SUM(COALESCE(x.paid,0))/NULLIF(SUM(s.statement_amount),0),2) AS collection_pct FROM customers c JOIN credit_cards cc USING(customer_id) JOIN statements s USING(card_id) LEFT JOIN (SELECT statement_id,SUM(CASE WHEN payment_status='Completed' THEN payment_amount ELSE 0 END) AS paid FROM payments GROUP BY statement_id) x USING(statement_id) GROUP BY c.customer_id,c.customer_name ORDER BY collection_pct;

