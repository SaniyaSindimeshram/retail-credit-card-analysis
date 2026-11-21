# Retail Credit Card Portfolio & Delinquency Analysis

## 1. Project Overview

A SQLite-based SQL portfolio project focused on analyzing a synthetic retail credit card portfolio, payment behaviour, billed exposure, outstanding balances, and delinquency patterns.

**Database:** SQLite  
**Dataset:** Deterministically generated synthetic data  
**Analysis Cutoff Date:** 19 November 2026

All records are synthetic and do not represent real customers, banks, or financial institutions.

## 2. Business Objectives

- Analyze customer profiles, credit cards, and assigned credit limits.
- Measure total billed amounts, completed payments, and outstanding balances.
- Examine payment behaviour and collection performance.
- Compare statement balances with assigned credit limits as a billed-exposure proxy.
- Identify overdue statements and calculate Days Past Due (DPD).
- Analyze payment outcomes and customer-level financial exposure.
- Generate repeatable SQL reports for portfolio-level and customer-level analysis.

## 3. Dataset Description

The project contains four relational tables:

| Table | Records | Description |
|---|---:|---|
| customers | 100 | Synthetic customer information and annual income |
| credit_cards | 120 | Card ownership, card type, and credit limits |
| statements | 600 | Statement amounts, statement dates, and due dates |
| payments | 600 | Payment amounts, dates, and payment statuses |

The corresponding CSV files are available in the `data/` directory.

Primary and foreign keys establish relationships between customers, credit cards, statements, and payments.

## 4. Database Schema

The database consists of four interconnected tables:

- `customers`: Primary key — `customer_id`
- `credit_cards`: Primary key — `card_id`; foreign key — `customer_id`
- `statements`: Primary key — `statement_id`; foreign key — `card_id`
- `payments`: Primary key — `payment_id`; foreign key — `statement_id`

## 5. SQL Concepts Demonstrated

- CREATE TABLE and INSERT
- PRIMARY KEY and FOREIGN KEY constraints
- CHECK constraints
- SELECT, WHERE, and ORDER BY
- GROUP BY and HAVING
- Aggregate functions
- INNER JOIN and LEFT JOIN
- Subqueries
- CASE WHEN
- COALESCE and NULLIF
- Date functions
- Conditional calculations
- Days Past Due (DPD) calculations
- Customer-level and portfolio-level aggregations

## 6. Analysis Categories

The project includes 30 numbered SQL analysis tasks organized into five categories.

| Category | Tasks | Analysis Focus |
|---|---|---|
| Basic Portfolio Analysis | 01–05 | Customer, card, and portfolio overview |
| Credit Utilization Analysis | 06–10 | Credit limits and billed exposure |
| Payment Behaviour Analysis | 11–15 | Payment patterns and collection performance |
| Delinquency Analysis | 16–20 | Overdue statements and DPD |
| Settlement Analysis | 21–30 | Outstanding balances and customer-level analysis |

The SQL scripts are organized in the `sql/` directory.

## 7. Key Business Findings

The following figures were calculated from the included synthetic SQLite database.

| Metric | Result |
|---|---:|
| Total Billed Amount | ₹2,03,91,000.00 |
| Completed Payments | ₹1,23,00,070.44 |
| Outstanding Balance | ₹80,90,929.56 |
| Collection Rate | 60.32% |
| Overdue Statements | 298 |

### Key Observations

- Total billed statement amounts are approximately ₹2.04 crore.
- Completed payments account for 60.32% of the total billed amount.
- The outstanding balance is approximately ₹80.91 lakh.
- A total of 298 statements were identified as overdue with an outstanding balance at the analysis cutoff date.

These findings describe the constructed dataset and should not be interpreted as real-world banking statistics.

Detailed query-level results are available in `results/query_outputs/`.

## 8. Project Structure

```text
retail-credit-card-analysis/
│
├── README.md
├── retail_credit_card_analysis.db
│
├── data/
│   ├── customers.csv
│   ├── credit_cards.csv
│   ├── statements.csv
│   └── payments.csv
│
├── sql/
│   ├── 01_database_schema.sql
│   ├── 02_data_insertion.sql
│   ├── 03_basic_portfolio_analysis.sql
│   ├── 04_credit_utilization_analysis.sql
│   ├── 05_payment_behaviour_analysis.sql
│   ├── 06_delinquency_analysis.sql
│   └── 07_settlement_analysis.sql
│
└── results/
    ├── query_outputs/
    │   ├── task_01.csv
    │   ├── ...
    │   ├── task_30.csv
    │   └── verification_report.txt
    │
    └── screenshots/
```

## 9. How to Run the Project

### Option A: Using an SQLite Desktop Application

The ready-to-open database file is included in the project.

1. Open `retail_credit_card_analysis.db` using an SQLite-compatible desktop application.
2. Explore the database tables and their records.
3. Open the SQL scripts in the `sql/` directory.
4. Execute the required analysis queries and review their outputs.

To recreate the database from scratch, use a new or empty SQLite database and execute the scripts in numerical order.

### Option B: Using SQLite3 Fiddle

1. Visit [SQLite3 Fiddle](https://sqlite.org/fiddle/).
2. Paste and execute the contents of `01_database_schema.sql`.
3. Execute `02_data_insertion.sql`.
4. Execute the analysis scripts from `03` through `07` in numerical order.
5. Review the query results.

Execute the scripts in a fresh database session to avoid conflicts with existing tables or records. The analysis scripts contain multiple SELECT statements, which should be executed according to the editor's supported execution options.

## 10. Verification and Testing

The 30 SQL analysis tasks were programmatically checked for execution errors.

Additional programmatic checks included:

- Foreign key constraint violations.
- Payment amount consistency.
- Outstanding balance calculations.
- Valid payment status values.

The project includes:

- `verification_report.txt`
- 30 individual task result CSV files (`task_01.csv` to `task_30.csv`)

**Verification limitation:** Independent end-to-end execution of all scripts in SQLite3 Fiddle has not yet been completed.

## 11. Data Limitations and Assumptions

- All records are synthetic and generated for educational and portfolio purposes.
- The dataset is not statistically representative of an actual credit card portfolio.
- The statement-to-credit-limit ratio is a billed-exposure proxy. It is not a real-time credit utilization measure because the dataset does not comprehensively model daily transactions or statement-cycle balances.
- DPD is evaluated at the fixed cutoff date of 19 November 2026 for statements with a remaining completed-payment balance and a due date before the cutoff.
- Pending and failed payment amounts are not counted as completed collections.
- This project is intended for SQL learning and portfolio demonstration only. It should not be used for lending, underwriting, credit scoring, or regulatory decisions.

## 12. Technologies Used

- SQLite
- SQL
- CSV
- GitHub

## 13. Project Purpose

This project demonstrates practical SQL application through relational database design, data retrieval, joins, aggregation, conditional logic, payment analysis, delinquency calculations, and business-oriented reporting.

It was developed as a portfolio project to demonstrate SQL-based financial data analysis skills for Data Analyst and SQL internship opportunities.