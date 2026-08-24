# DataCo Global Supply Chain Analytics

End-to-end analysis of DataCo's global supply chain operations, covering customer behavior, product profitability, market performance, and logistics efficiency — built using Python, SQL, Excel, and Power BI.

## Overview

This project analyzes ~180,000 order records from DataCo's supply chain dataset to answer a core business question: **where is DataCo winning, where is it leaking profit, and what should management prioritize next?**

Each tool in this repo covers a different layer of the analysis:
- **Python** – data cleaning, validation, and exploratory analysis
- **SQL** – business-question-driven queries (customer value, profitability, rankings, KPIs)
- **Excel** – interactive product lookup tool and discount/pricing scenario simulator
- **Power BI** – executive dashboard for at-a-glance monitoring

## Business Questions Answered

- Who are the highest revenue and highest profit customers?
- Which countries and markets are most profitable, not just highest-selling?
- How do customer segments compare in sales, profit, and order volume?
- Which shipping modes are fastest and most profitable?
- How does monthly performance trend over time?
- Which products lead each category and each region?
- How should customers be segmented by purchase frequency (one-time vs. repeat vs. loyal)?
- Does discounting actually help or hurt profitability?

## Key Insights

- DataCo generated **over $36.78M in sales** across **65,752 orders** and **20,652 unique customers**, with an average order value of ~$203.77 and average profit per order of ~$21.97.
- **Discounting erodes profitability**: average profit per order item declines from **$23.94** (0–5% discount) to **$18.41** (20–25% discount) — a **~23% reduction** — while the rate of loss-making orders stays roughly flat across discount bands. Larger discounts do not reliably improve outcomes.
- A small number of products and categories drive a disproportionate share of revenue and profit, consistent with the Pareto principle — supporting focused inventory and merchandising prioritization.
- Monthly revenue is relatively stable with limited seasonality; February is the weakest month, October and January the strongest, within the complete-data period (see Data Limitations below).
- Most shipping modes deliver within the expected window, but mode-level comparison surfaces clear differences in delay rates and profitability.

## Data Limitations

The dataset spans **January 2015 – January 2018**, but order volume drops sharply from October 2017 onward (roughly 2,100–2,250 orders/month, down from a steady ~5,000–5,400/month in every prior month). This is a **data completeness cutoff, not a real business decline** — the final ~4 months of the dataset are only partially populated. Time-based analyses (monthly trends, seasonality, year-over-year comparisons) in this project exclude or flag this partial period so it isn't misread as an actual drop in demand.

## Dashboard Preview

The repo includes three Power BI dashboard pages — Executive Summary, Customer & Product Insights, and Supply Chain & Logistics — see the `/images` folder for screenshots.

## Project Structure
dataco-supply-chain-analytics/
├── README.md
├── notebooks/
│ └── dataco_supply_chain_eda.ipynb
├── sql/
│ └── dataco_supply_chain_queries.sql
├── excel/
│ └── dataco_supply_chain_workbook.xlsx
├── powerbi/
│ └── dataco_supply_chain_dashboard.pbix
├── images/
│ └── (dashboard screenshots)
└── data/
└── data_source.md

## Tools & Tech Stack

- **Python**: pandas, numpy, matplotlib, seaborn
- **SQL**: MySQL — aggregate functions, CTEs, window functions (`DENSE_RANK`), CASE statements
- **Excel**: INDEX/MATCH lookups, PivotTables, scenario/what-if modeling
- **Power BI**: interactive report with data model built on the cleaned dataset

## About the Excel Workbook

The workbook contains a mix of static and live components, by design:

- **Pivot_analysis** and **Decision_tool** sheets show results computed on the **complete ~180,000-row dataset**, saved as static values. This keeps the file lightweight (under 3 MB) while preserving the actual full-scale results.
- **Product_lookup** and **Scenario_Analysis** sheets remain **fully formula-driven** (INDEX/MATCH, IFERROR, conditional logic) against a representative ~5,000-row sample in **Raw_data**, so the interactive tools are genuinely live — select a product from the dropdown or adjust scenario inputs and watch it recalculate.
- The **Raw_data** tab contains a sample rather than the full dataset purely for file-size reasons. Repopulating it with the complete dataset (see below) reproduces identical results at full scale.

## Data Source

This project uses the publicly available **DataCo Global Supply Chain dataset** from Kaggle: [DataCo SMART SUPPLY CHAIN FOR BIG DATA ANALYSIS](https://www.kaggle.com/datasets/shashwatwork/dataco-smart-supply-chain-for-big-data-analysis)

The full raw dataset is not included in this repo due to its size (~180K rows). See `data/data_source.md` for the download link and loading instructions.

## How to Reproduce

1. Download the dataset from the Kaggle link above.
2. Run `notebooks/dataco_supply_chain_eda.ipynb` end-to-end to clean and export the processed dataset.
3. Load the cleaned CSV into MySQL as a table named `dataco_cleaned`, then run `sql/dataco_supply_chain_queries.sql`.
4. Open `excel/dataco_supply_chain_workbook.xlsx` — to work with the full dataset instead of the sample, paste the complete cleaned CSV into the `Raw_data` tab starting at row 2.
5. Open `powerbi/dataco_supply_chain_dashboard.pbix` in Power BI Desktop to explore the interactive report.

## Author

**Anushka Bidawat**
[LinkedIn](https://www.linkedin.com/in/anushkabidawat/)
