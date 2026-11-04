
-- ============================================================
-- Project: Azure Retail Sales Data Engineering
-- Script: 07_revenue_by_customer_segment.sql
-- Purpose: Analyse revenue by customer segment
-- Platform: Azure Synapse Analytics - Serverless SQL
--
-- Business metrics:
-- 1. Total transactions per customer segment
-- 2. Total units sold per segment
-- 3. Total revenue in GBP
-- 4. Average transaction value in GBP
--
-- Data quality handling:
-- Missing customer segments are classified as 'Unknown'
--
-- Source: dbo.vw_retail_sales_enriched
-- ============================================================

CREATE OR ALTER VIEW dbo.vw_revenue_by_customer_segment
AS
SELECT
    -- Include customers with missing segment information
    COALESCE(CustomerSegment, 'Unknown') AS CustomerSegment,

    -- Count transactions by customer segment
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

FROM dbo.vw_retail_sales_enriched

GROUP BY
    COALESCE(CustomerSegment, 'Unknown');
