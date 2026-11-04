
-- ============================================================
-- Project: Azure Retail Sales Data Engineering
-- Script: 08_revenue_by_loyalty_tier.sql
-- Purpose: Analyse retail revenue by customer loyalty tier
-- Platform: Azure Synapse Analytics - Serverless SQL
--
-- Business metrics:
-- 1. Total transactions by loyalty tier
-- 2. Total units sold by loyalty tier
-- 3. Total revenue in GBP
-- 4. Average transaction value in GBP
--
-- Data quality:
-- Missing loyalty tier values are classified as 'Unknown'
--
-- Source: dbo.vw_retail_sales_enriched
-- ============================================================

-- STEP 1: Create the loyalty tier revenue analytics view

CREATE OR ALTER VIEW dbo.vw_revenue_by_loyalty_tier
AS
SELECT
    -- Handle missing loyalty tier information
    COALESCE(LoyaltyTier, 'Unknown') AS LoyaltyTier,

    -- Count transactions for each loyalty tier
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

FROM dbo.vw_retail_sales_enriched

GROUP BY
    COALESCE(LoyaltyTier, 'Unknown');
