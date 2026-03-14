# Northwind SQL Business Analysis

## Project Overview
This project analyzes business performance using the **Northwind database**, a classic retail dataset representing a wholesale food distribution company.
Data: https://github.com/pthom/northwind_psql 

The objective of the project is to demonstrate advanced SQL skills by answering real-world business questions related to:

- Sales performance
- Customer behavior
- Product performance
- Employee productivity

Using PostgreSQL, I developed analytical queries that simulate the type of reporting and exploratory analysis performed by data analysts in business environments.

Key SQL techniques demonstrated include:

- Common Table Expressions (CTEs)
- Window functions
- Ranking functions
- Multi-table joins
- Aggregations
- Analytical metrics

# Database Schema

The Northwind dataset contains information about orders, customers, products, and employees.

| Table | Description |
|------|-------------|
| customers | customer information |
| orders | individual orders |
| order_details | line items within orders |
| products | product catalog |
| categories | product categories |
| employees | sales employees |
| shippers | shipping companies |

# Project Structure

## Analysis Overview

This project answers business questions across four key areas of the Northwind database.

### Sales Analysis
Examines overall revenue performance across products, categories, countries, and employees.

Key questions:
- Which products and categories generate the most revenue?
- Which countries produce the highest sales?
- How does revenue trend month-to-month?

---

### Customer Analysis
Identifies high-value customers and revenue concentration.

Key questions:
- Which customers contribute the most revenue?
- What percentage of total revenue does each customer generate?
- How concentrated is revenue among top customers?

---

### Product Performance
Analyzes product performance within categories and over time.

Key questions:
- Which products generate the most revenue?
- How do products rank within their category?
- How do product rankings change month-to-month?
- Which products consistently rank in the top performers of their category?

---

### Employee Performance
Evaluates employee sales performance using multiple metrics.

Key questions:
- Which employees generate the highest average order value?
- Which employees sell across the widest variety of products and categories?

---

## Example Insights

This analysis can reveal insights such as:

- A small number of customers generating a large share of revenue
- Products that consistently dominate their categories
- Employees who generate fewer but higher-value orders
- Sales employees with broader product and category coverage

---

## How to Run the Queries

1. Load the **Northwind database** into PostgreSQL.
2. Open the SQL scripts in **DataGrip or another SQL client**.
3. Run each file individually to reproduce the analysis.

---



