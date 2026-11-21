-- 07_settlement_analysis.sql
-- Analysis cutoff date: 2026-11-19

-- Task 21 - Fully settled statements
SELECT s.statement_id,s.statement_amount,COALESCE(SUM(CASE WHEN p.payment_status='Completed' THEN p.payment_amount ELSE 0 END),0) AS paid FROM statements s LEFT JOIN payments p USING(statement_id) GROUP BY s.statement_id HAVING paid>=s.statement_amount ORDER BY s.statement_id;

-- Task 22 - Partially settled statements
SELECT s.statement_id,s.statement_amount,COALESCE(SUM(CASE WHEN p.payment_status='Completed' THEN p.payment_amount ELSE 0 END),0) AS paid,s.statement_amount-COALESCE(SUM(CASE WHEN p.payment_status='Completed' THEN p.payment_amount ELSE 0 END),0) AS balance FROM statements s LEFT JOIN payments p USING(statement_id) GROUP BY s.statement_id HAVING paid>0 AND balance>0 ORDER BY balance DESC;

-- Task 23 - Unpaid statements
SELECT s.statement_id,s.statement_amount FROM statements s LEFT JOIN payments p ON p.statement_id=s.statement_id AND p.payment_status='Completed' GROUP BY s.statement_id HAVING COALESCE(SUM(p.payment_amount),0)=0;

-- Task 24 - Settlement status summary
SELECT CASE WHEN paid=0 THEN 'Unpaid' WHEN paid<statement_amount THEN 'Partially paid' ELSE 'Settled' END AS settlement_status,COUNT(*) AS statement_count,SUM(statement_amount-paid) AS remaining_balance FROM (SELECT s.statement_id,s.statement_amount,COALESCE(SUM(CASE WHEN p.payment_status='Completed' THEN p.payment_amount ELSE 0 END),0) paid FROM statements s LEFT JOIN payments p USING(statement_id) GROUP BY s.statement_id) GROUP BY settlement_status ORDER BY settlement_status;

-- Task 25 - Average payment amount
SELECT ROUND(AVG(payment_amount),2) AS average_payment FROM payments WHERE payment_status='Completed';


-- Risk and customer segmentation (Tasks 26-30)
-- Task 26 - Customers with overdue exposure above 10000
SELECT c.customer_name,SUM(s.statement_amount-COALESCE(x.paid,0)) AS overdue_balance FROM customers c JOIN credit_cards cc USING(customer_id) JOIN statements s USING(card_id) LEFT JOIN (SELECT statement_id,SUM(CASE WHEN payment_status='Completed' THEN payment_amount ELSE 0 END) paid FROM payments GROUP BY statement_id) x USING(statement_id) WHERE date(s.due_date)<'2026-11-19' GROUP BY c.customer_id HAVING overdue_balance>10000 ORDER BY overdue_balance DESC;

-- Task 27 - Income band segmentation
SELECT customer_name,annual_income,CASE WHEN annual_income<600000 THEN 'Below 6L' WHEN annual_income<1000000 THEN '6L-10L' ELSE '10L+' END AS income_band FROM customers ORDER BY annual_income;

-- Task 28 - Customer risk snapshot
SELECT c.customer_name,COUNT(DISTINCT s.statement_id) AS statements,ROUND(SUM(s.statement_amount),2) AS billed,ROUND(SUM(s.statement_amount-COALESCE(x.paid,0)),2) AS outstanding FROM customers c LEFT JOIN credit_cards cc USING(customer_id) LEFT JOIN statements s USING(card_id) LEFT JOIN (SELECT statement_id,SUM(CASE WHEN payment_status='Completed' THEN payment_amount ELSE 0 END) paid FROM payments GROUP BY statement_id) x USING(statement_id) GROUP BY c.customer_id ORDER BY outstanding DESC;

-- Task 29 - Customers without any overdue balance
SELECT c.customer_name FROM customers c WHERE NOT EXISTS (SELECT 1 FROM credit_cards cc JOIN statements s USING(card_id) LEFT JOIN (SELECT statement_id,SUM(CASE WHEN payment_status='Completed' THEN payment_amount ELSE 0 END) paid FROM payments GROUP BY statement_id) x USING(statement_id) WHERE cc.customer_id=c.customer_id AND date(s.due_date)<'2026-11-19' AND s.statement_amount-COALESCE(x.paid,0)>0);

-- Task 30 - Portfolio KPI dashboard
SELECT (SELECT COUNT(*) FROM customers) AS customers,(SELECT COUNT(*) FROM credit_cards) AS cards,(SELECT SUM(credit_limit) FROM credit_cards) AS total_credit_limit,(SELECT SUM(statement_amount) FROM statements) AS total_billed,(SELECT SUM(payment_amount) FROM payments WHERE payment_status='Completed') AS total_collected,(SELECT SUM(s.statement_amount-COALESCE(x.paid,0)) FROM statements s LEFT JOIN (SELECT statement_id,SUM(CASE WHEN payment_status='Completed' THEN payment_amount ELSE 0 END) paid FROM payments GROUP BY statement_id) x USING(statement_id)) AS outstanding;

