# Northwind SQL Analysis

An exploratory analysis of the Northwind sample database using SQL Server,
focused on customer value, product category trends, and sales rep performance.
Built as a portfolio project to practice window functions, CTEs, and 
business-oriented data analysis.
**Dataset:** [Northwind sample database](https://github.com/microsoft/sql-server-samples/tree/master/samples/databases/northwind-pubs)
**Tools:** SQL Server · VS Code (mssql extension)

---

## Analysis 1: Top Customers by Lifetime Value
**Query:** [Top customers by total sales.sql](Queries/top_customers.sql)

**Business question:** Who are the top customers by lifetime value, and how 
does their average order size compare to the rest?

**Findings:**

Revenue is highly concentrated at the top. Three customers — QUICK-Stop ($117K),
Save-a-lot Markets ($116K), and Ernst Handel ($113K) — together account for 25.6%
of total revenue. The top 10 represent 45.5% of all $1.35M in sales, leaving 89
customers competing for the remaining 54.5%.

These top 3 are also high-frequency buyers, but in different ways. Save-a-lot leads
on raw order count (116 orders), while QUICK-Stop has fewer orders but a notably
higher average order value ($1,366 vs $997). Ernst Handel sits in between — 102
orders at $1,110 AOV — making it the most balanced of the three.

A two-cluster pattern emerges: the top 3 sit in a high-orders/high-AOV zone, while
the remaining top-10 customers are scattered with lower order counts. No other 
customer combines both high volume and high ticket size. 
[Top Customers.png](Dashboards/Top_Customers.png)

Most customers are low-frequency buyers. Only 6 customers placed 50+ orders, 39 are
mid-tier (20–49), and 44 placed fewer than 20 orders — a very thin "loyal 
high-volume" segment. The top 3 customers are worth protecting aggressively.

Note: excludes discount adjustment — figures are pre-discount gross sales
---

## Analysis 2: Category Revenue Share Over Time
**Query:** [Category revenue per year.sql](Queries/category_revenue_by_year.sql)

**Business question:** Which product categories generate the most revenue, and is 
that share growing or shrinking over time?

**Findings:**

Beverages and Dairy Products dominate. Across all three years, Beverages leads with
$268K (21.2% of total), followed by Dairy Products at $235K (18.5%). Together they
account for nearly 40% of all revenue. Confections and Meat/Poultry are a solid 
third tier (~13% each), while Grains/Cereals sits last at 7.6%.

Beverages is the standout share winner — its share dropped in 1997 (23% → 17%) but 
rebounded sharply in 1998 to 26%, its highest point. It is the only category that 
ended meaningfully above where it started.

Dairy Products, Confections, and Meat/Poultry are all on a slow decline, each losing
1–2 percentage points per year consistently. Large in absolute terms, but shrinking 
as a proportion of the mix — worth watching.

Grains/Cereals had the most dramatic swing: surging from 4.6% to 9.2% share in 1997
(a nearly 500% revenue jump), then falling back to 6.7% in 1998 — likely a single
large order or seasonal spike rather than a structural trend.

**Caveat:** 1998 revenue totals only $441K vs $617K in 1997, indicating the 1998 
data is likely partial (cut off mid-year). Apparent YoY declines in 1998 are 
probably a data truncation artifact, not real contraction — share trends *within* 
each year are more reliable than raw growth rates *between* years. (This is a mock data set) 

---

## Analysis 3: Sales Rep Performance vs. Regional Average
**Query:** [Sales rep performance.sql](Queries/sales_rep_performance.sql)

**Business question:** Which sales reps are performing above or below average 
relative to their region?

**Findings:**

Margaret Peacock leads the team in total revenue and maintains a consistently 
above-average rate, suggesting her output reflects steady execution rather than 
a handful of outlier months.

Laura Callahan shows the highest volatility on the team — her best month reached 
~$20.9K, but she also logged several near-zero months ($106, $385, $704) with no 
reliable floor. This pattern is worth investigating to understand what support 
might help.

**Key methodological note:** An initial query ranked Laura as the lowest performer 
overall. Adding a time dimension (year + month) reversed that conclusion — she 
performs above average more consistently than her raw total suggested. This 
highlights an important limitation: cumulative totals can reflect tenure or 
start date rather than actual performance quality. Window functions partitioned 
by time period give a fairer picture.

---

## Methodology Notes

- **Aggregation grain:** Early drafts of the customer analysis aggregated at the 
  order-detail level rather than the customer level, inflating some counts. Final 
  queries aggregate at the correct grain.
- **Window functions and WHERE clauses:** Filtering with WHERE after a window 
  function can silently change what the window compares against. CTEs were used 
  to calculate averages before filtering to avoid this.
- **Partial-year data:** 1998 appears to be a partial year in the Northwind dataset.
  Raw YoY comparisons for 1998 should be treated with caution in further analysis.