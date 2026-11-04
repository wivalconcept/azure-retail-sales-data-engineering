
-- ============================================================
-- Project: Azure Retail Sales Data Engineering
-- Script: 11_monthly_revenue.sql
-- Purpose: Analyse monthly retail sales and revenue trends
-- Platform: Azure Synapse Analytics - Serverless SQL
--
-- Business metrics:
-- 1. Total transactions per month
-- 2. Total units sold per month
-- 3. Total monthly revenue in GBP
-- 4. Average transaction value in GBP
--
-- Source: dbo.vw_retail_sales_clean
-- ============================================================

-- STEP 1: Create the monthly revenue analytics view

CREATE OR ALTER VIEW dbo.vw_monthly_revenue
AS
SELECT
    -- Extract the transaction year
    YEAR(TransactionDate) AS SalesYear,

    -- Extract the transaction month
    MONTH(TransactionDate) AS SalesMonth,

    -- Count monthly transactions
    COUNT(*) AS TotalTransactions,

    -- Calculate total units sold per month
    SUM(Quantity) AS TotalUnitsSold,

    -- Calculate total monthly revenue in GBP
    CAST(
        SUM(TotalAmountGBP) AS DECIMAL(18,2)
    ) AS TotalRevenueGBP,

    -- Calculate average transaction value
    CAST(
        AVG(TotalAmountGBP) AS DECIMAL(18,2)
    ) AS AverageTransactionGBP

FROM dbo.vw_retail_sales_clean

-- Group by both year and month to keep
-- transactions from different years separate
GROUP BY
    YEAR(TransactionDate),
    MONTH(TransactionDate);
