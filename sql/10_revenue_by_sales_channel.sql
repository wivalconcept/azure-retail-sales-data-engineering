
-- ============================================================
-- Project: Azure Retail Sales Data Engineering
-- Script: 10_revenue_by_sales_channel.sql
-- Purpose: Analyse retail revenue by sales channel
-- Platform: Azure Synapse Analytics - Serverless SQL
--
-- Business metrics:
-- 1. Total transactions by sales channel
-- 2. Total units sold by sales channel
-- 3. Total revenue in GBP
-- 4. Average transaction value in GBP
--
-- Source: dbo.vw_retail_sales_clean
-- ============================================================

-- STEP 1: Create the sales channel analytics view

CREATE OR ALTER VIEW dbo.vw_revenue_by_sales_channel
AS
SELECT
    -- Identify the sales channel
    SalesChannel,

    -- Count transactions for each sales channel
    COUNT(*) AS TotalTransactions,

    -- Calculate total units sold
    SUM(Quantity) AS TotalUnitsSold,

    -- Calculate total revenue in GBP
    CAST(
        SUM(TotalAmountGBP) AS DECIMAL(18,2)
    ) AS TotalRevenueGBP,

    -- Calculate average transaction value
    CAST(
        AVG(TotalAmountGBP) AS DECIMAL(18,2)
    ) AS AverageTransactionValueGBP

FROM dbo.vw_retail_sales_clean

GROUP BY SalesChannel;
