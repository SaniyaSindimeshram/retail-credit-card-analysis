-- 06_delinquency_analysis.sql
-- Analysis cutoff date: 2026-11-19

-- Task 16 - Outstanding by statement
SELECT s.statement_id, s.due_date, s.statement_amount, COALESCE(SUM(CASE WHEN p.payment_status='Completed' THEN p.payment_amount ELSE 0 END),0) AS paid, s.statement_amount-COALESCE(SUM(CASE WHEN p.payment_status='Completed' THEN p.payment_amount ELSE 0 END),0) AS outstanding FROM statements s LEFT JOIN payments p USING(statement_id) GROUP BY s.statement_id ORDER BY s.statement_id;

-- Task 17 - Overdue statements at cutoff
SELECT s.statement_id,s.due_date,s.statement_amount-COALESCE(SUM(CASE WHEN p.payment_status='Completed' THEN p.payment_amount ELSE 0 END),0) AS outstanding FROM statements s LEFT JOIN payments p USING(statement_id) WHERE date(s.due_date)<'2026-11-19' GROUP BY s.statement_id HAVING outstanding>0 ORDER BY s.due_date;

-- Task 18 - DPD for overdue balances
SELECT s.statement_id, MAX(0, CAST(julianday('2026-11-19')-julianday(s.due_date) AS INTEGER)) AS dpd FROM statements s LEFT JOIN payments p USING(statement_id) GROUP BY s.statement_id HAVING s.statement_amount-COALESCE(SUM(CASE WHEN p.payment_status='Completed' THEN p.payment_amount ELSE 0 END),0)>0 AND date(s.due_date)<'2026-11-19' ORDER BY dpd DESC;

-- Task 19 - Delinquency bucket
SELECT statement_id, outstanding, dpd, CASE WHEN dpd BETWEEN 1 AND 30 THEN '1-30 days' WHEN dpd BETWEEN 31 AND 60 THEN '31-60 days' WHEN dpd BETWEEN 61 AND 90 THEN '61-90 days' ELSE '90+ days' END AS delinquency_bucket FROM (SELECT s.statement_id,s.statement_amount-COALESCE(SUM(CASE WHEN p.payment_status='Completed' THEN p.payment_amount ELSE 0 END),0) AS outstanding,CAST(julianday('2026-11-19')-julianday(s.due_date) AS INTEGER) AS dpd FROM statements s LEFT JOIN payments p USING(statement_id) WHERE date(s.due_date)<'2026-11-19' GROUP BY s.statement_id HAVING outstanding>0) ORDER BY dpd DESC;

-- Task 20 - Overdue exposure by customer
SELECT c.customer_name, SUM(s.statement_amount-COALESCE(x.paid,0)) AS overdue_outstanding FROM customers c JOIN credit_cards cc USING(customer_id) JOIN statements s USING(card_id) LEFT JOIN (SELECT statement_id,SUM(CASE WHEN payment_status='Completed' THEN payment_amount ELSE 0 END) paid FROM payments GROUP BY statement_id) x USING(statement_id) WHERE date(s.due_date)<'2026-11-19' GROUP BY c.customer_id,c.customer_name HAVING overdue_outstanding>0 ORDER BY overdue_outstanding DESC;

