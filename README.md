# U.S. Food & Gas Price Trends: 2022–2026

## Project Overview

This project analyzes U.S. average prices for selected food items and regular gasoline from January 2022 through August 2026.

The goal is to understand how prices changed over time, compare price changes across items, and identify items with the largest increases and decreases.

The project uses BLS Average Price Data and demonstrates a complete data analytics workflow using SQL Server and Power BI.

## Business Questions

- What was the average price of each item by year?
- How did prices change from 2022 to 2026?
- Which items experienced the largest price increases?
- Which items experienced the largest decreases?
- Which items had the greatest monthly price volatility?
- How did gasoline prices compare with food prices?
- How did individual prices change month by month?

## Data Source

U.S. Bureau of Labor Statistics (BLS) Average Price Data.

Data period used in the analysis:

**January 2022 – August 2026**

The project uses average price data rather than CPI index data.

## Items Analyzed

The project includes:

- Regular gasoline
- Eggs, Grade A, Large
- Whole milk
- White bread
- Ground beef
- Chicken breast
- All-purpose flour
- White rice
- Spaghetti/macaroni
- Ground coffee

## Tools Used

- SQL Server
- T-SQL
- Power BI
- DAX
- Microsoft Excel / CSV data

## Data Pipeline

The project follows a basic ETL and dimensional modeling workflow:

Raw Data  
↓  
Staging Data  
↓  
Dimension Tables + Fact Table  
↓  
SQL Analysis  
↓  
Power BI Dashboard

## SQL Data Model

The Power BI model uses a simple star schema.

### Dimension Tables

- `dim_date`
- `dim_item`

### Fact Table

- `fact_prices`

The fact table contains the monthly price observations and connects to the dimension tables through keys.

## SQL Analysis

SQL was used for:

- Data loading
- Data quality checks
- NULL-value handling
- Date filtering
- Dimension and fact table creation
- Annual price analysis
- January–August 2022 vs. January–August 2026 comparison
- Month-over-month price changes
- Year-over-year price changes
- Price volatility
- Price normalization
- Validation checks

## Power BI Dashboard

The Power BI dashboard includes:

- U.S. Food & Gas Price Index
- Largest price increase KPI
- Largest increase item KPI
- Largest decrease KPI
- Largest decrease item KPI
- Price change comparison
- Monthly actual price trends
- Summary table
- Food/Gas, item, and year filters

## Key Findings

Using January–August averages for 2022 and 2026:

- Ground coffee had the largest increase among the items analyzed.
- Ground beef had the second-largest increase.
- Eggs and regular gasoline were lower in 2026 than in 2022 over the same January–August comparison period.
- Price changes varied significantly between individual food categories.

These findings are descriptive comparisons of the BLS average-price data and do not establish the causes of price changes.

## Power BI Dashboard Screenshots

### Dashboard Overview

![Dashboard Overview](dashboard_overview.png)

### Price Analysis

![Price Analysis](price_analysis.png)

### Summary Table

![Summary Table](summary_table.png)

## Project Structure

```text
Food_Gas_Price_Project
│
├── data
│   ├── raw
│   ├── staging
│   └── final
│
├── python
│
├── sql
│   └── food_gas_price_analysis.sql
│
├── powerbi
│   └── Food_Gas_Price_Analysis.pbix
│
├── screenshots
│   ├── dashboard_overview.png
│   ├── price_analysis.png
│   └── summary_table.png
│
└── docs
