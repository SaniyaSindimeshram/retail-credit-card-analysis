-- 01_database_schema.sql
-- Synthetic retail credit card portfolio. Analysis cutoff: 2026-11-19.
PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS statements;
DROP TABLE IF EXISTS credit_cards;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    customer_name TEXT NOT NULL,
    age INTEGER NOT NULL CHECK (age >= 18),
    city TEXT NOT NULL,
    annual_income REAL NOT NULL CHECK (annual_income >= 0)
);

CREATE TABLE credit_cards (
    card_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    card_type TEXT NOT NULL,
    credit_limit REAL NOT NULL CHECK (credit_limit > 0),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE statements (
    statement_id INTEGER PRIMARY KEY,
    card_id INTEGER NOT NULL,
    statement_amount REAL NOT NULL CHECK (statement_amount >= 0),
    statement_date TEXT NOT NULL,
    due_date TEXT NOT NULL,
    FOREIGN KEY (card_id) REFERENCES credit_cards(card_id),
    CHECK (date(due_date) >= date(statement_date))
);

CREATE TABLE payments (
    payment_id INTEGER PRIMARY KEY,
    statement_id INTEGER NOT NULL,
    payment_amount REAL NOT NULL CHECK (payment_amount >= 0),
    payment_date TEXT,
    payment_status TEXT NOT NULL CHECK (payment_status IN ('Completed','Pending','Failed')),
    FOREIGN KEY (statement_id) REFERENCES statements(statement_id)
);
