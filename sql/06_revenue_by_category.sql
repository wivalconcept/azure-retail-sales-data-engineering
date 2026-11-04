
-- ============================================================
-- Project: Azure Retail Sales Data Engineering
-- Script: 06_revenue_by_category.sql
-- Purpose: Analyse retail sales performance by product category
-- Platform: Azure Synapse Analytics - Serverless SQL
--
-- Business metrics:
-- 1. Total transactions by product category
-- 2. Total units sold by category
-- 3. Total revenue in GBP
-- 4. Average transaction value in GBP
--
-- Source: dbo.vw_retail_sales_clean
-- ============================================================

-- STEP 1: Create the product category analytics view

CREATE OR ALTER VIEW dbo.vw_revenue_by_category
AS
SELECT
    Category,

    -- Count transactions in each category
    COUNT(*) AS TotalTransactions,

    -- Calculate total units sold
    SUM(Quantity) AS TotalUnitsSold,

    -- Calculate total revenue
    CAST(
        SUM(TotalAmountGBP) AS DECIMAL(18,2)
    ) AS TotalRevenueGBP,

    -- Calculate average transaction value
    CAST(
        AVG(TotalAmountGBP) AS DECIMAL(18,2)
    ) AS AverageTransactionValueGBP

FROM dbo.vw_retail_sales_clean

GROUP BY Category;


-- STEP 2: Rank product categories by total revenue

SELECT *
FROM dbo.vw_revenue_by_category
ORDER BY TotalRevenueGBP DESC;


-- STEP 3: Validate aggregated transaction counts and revenue

SELECT
    SUM(TotalTransactions) AS TotalTransactions,
    SUM(TotalRevenueGBP) AS TotalRevenueGBP
FROM dbo.vw_revenue_by_category;
