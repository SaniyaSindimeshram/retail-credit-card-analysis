-- 03_basic_portfolio_analysis.sql
-- Analysis cutoff date: 2026-11-19

-- Task 01 - Customer count
SELECT COUNT(*) AS total_customers FROM customers;

-- Task 02 - Card count and types
SELECT card_type, COUNT(*) AS cards FROM credit_cards GROUP BY card_type ORDER BY cards DESC, card_type;

-- Task 03 - Portfolio credit limit
SELECT SUM(credit_limit) AS total_credit_limit FROM credit_cards;

-- Task 04 - Statement totals by month
SELECT strftime('%Y-%m', statement_date) AS statement_month, COUNT(*) AS statements, SUM(statement_amount) AS billed_amount FROM statements GROUP BY statement_month ORDER BY statement_month;

-- Task 05 - Customer profile with card count
SELECT c.customer_id, c.customer_name, c.city, COUNT(cc.card_id) AS card_count FROM customers c LEFT JOIN credit_cards cc ON cc.customer_id=c.customer_id GROUP BY c.customer_id, c.customer_name, c.city ORDER BY card_count DESC, c.customer_name;

