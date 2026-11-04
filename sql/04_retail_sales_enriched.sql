
-- ============================================================
-- Project: Azure Retail Sales Data Engineering
-- Script: 04_retail_sales_enriched.sql
-- Purpose: Enrich clean sales data with customer information
-- Platform: Azure Synapse Analytics - Serverless SQL
--
-- Features:
-- 1. Combine clean sales and customer staging data
-- 2. Retain sales without matching customer records
-- 3. Include customer segmentation and loyalty information
-- 4. Identify matched and unmatched customers
-- ============================================================

CREATE OR ALTER VIEW dbo.vw_retail_sales_enriched
AS
SELECT
    s.TransactionID,
    s.TransactionDate,
    s.CustomerID,
    s.ProductID,
    s.Category,
    s.Quantity,
    s.UnitPriceGBP,
    s.DiscountPercent,
    s.PaymentMethod,
    s.SalesChannel,
    s.Region AS SalesRegion,
    s.TotalAmountGBP,

    -- Customer attributes
    c.CustomerSegment,
    c.Region AS CustomerRegion,
    c.SignupDate,
    c.LoyaltyTier,

    -- Identify customer matching status
    CASE
        WHEN c.CustomerID IS NULL
        THEN 'Unmatched Customer'
        ELSE 'Matched Customer'
    END AS CustomerMatchStatus

FROM dbo.vw_retail_sales_clean AS s

-- Retain all clean sales, including unmatched customers
LEFT JOIN dbo.vw_retail_customers_staging AS c
    ON s.CustomerID = c.CustomerID;
