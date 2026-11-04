
-- ============================================================
-- Project: Azure Retail Sales Data Engineering
-- Script: 05_revenue_by_region.sql
-- Purpose: Analyse retail sales performance by region
-- Platform: Azure Synapse Analytics - Serverless SQL
--
-- Business metrics:
-- 1. Total transactions per region
-- 2. Total units sold per region
-- 3. Total revenue in GBP
-- 4. Average transaction value in GBP
--
-- Source: dbo.vw_retail_sales_enriched
-- ============================================================

CREATE OR ALTER VIEW dbo.vw_revenue_by_region
AS
SELECT
    SalesRegion AS Region,

    -- Number of sales transactions
    COUNT(*) AS TotalTransactions,

    -- Total quantity of products sold
    SUM(Quantity) AS TotalUnitsSold,

    -- Total sales revenue
    CAST(
        SUM(TotalAmountGBP) AS DECIMAL(18,2)
    ) AS TotalRevenueGBP,

    -- Average revenue per transaction
    CAST(
        AVG(TotalAmountGBP) AS DECIMAL(18,2)
    ) AS AverageTransactionValueGBP

FROM dbo.vw_retail_sales_enriched

GROUP BY SalesRegion;
