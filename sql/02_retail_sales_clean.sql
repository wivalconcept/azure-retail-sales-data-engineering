
-- ============================================================
-- Project: Azure Retail Sales Data Engineering
-- Script: 02_retail_sales_clean.sql
-- Purpose: Validate and clean staged retail sales records
-- Platform: Azure Synapse Analytics - Serverless SQL
--
-- Data quality rules:
-- 1. Exclude transaction IDs that occur more than once
-- 2. Require non-empty transaction and customer IDs
-- 3. Validate transaction dates
-- 4. Require positive quantities
-- 5. Require non-negative unit prices and sales amounts
-- 6. Restrict discounts to the range 0-100
-- 7. Require a non-empty sales region
--
-- Validated result: 4,920 clean sales records
-- ============================================================

CREATE OR ALTER VIEW dbo.vw_retail_sales_clean
AS

WITH DuplicateCheck AS (
    SELECT
        TransactionID,
        COUNT(*) AS TransactionCount
    FROM dbo.vw_retail_sales_staging
    GROUP BY TransactionID
)

SELECT
    s.TransactionID,

    TRY_CAST(s.TransactionDate AS DATE)
        AS TransactionDate,

    s.CustomerID,
    s.ProductID,
    s.Category,

    TRY_CAST(s.Quantity AS INT)
        AS Quantity,

    TRY_CAST(s.UnitPriceGBP AS DECIMAL(18,2))
        AS UnitPriceGBP,

    TRY_CAST(s.DiscountPercent AS DECIMAL(5,2))
        AS DiscountPercent,

    s.PaymentMethod,
    s.SalesChannel,
    s.Region,

    TRY_CAST(s.TotalAmountGBP AS DECIMAL(18,2))
        AS TotalAmountGBP

FROM dbo.vw_retail_sales_staging AS s

INNER JOIN DuplicateCheck AS d
    ON s.TransactionID = d.TransactionID

WHERE
    d.TransactionCount = 1

    AND s.TransactionID IS NOT NULL
    AND LTRIM(RTRIM(s.TransactionID)) <> ''

    AND s.CustomerID IS NOT NULL
    AND LTRIM(RTRIM(s.CustomerID)) <> ''

    AND TRY_CAST(s.TransactionDate AS DATE) IS NOT NULL

    AND TRY_CAST(s.Quantity AS INT) > 0

    AND TRY_CAST(s.UnitPriceGBP AS DECIMAL(18,2)) >= 0

    AND TRY_CAST(s.DiscountPercent AS DECIMAL(5,2))
        BETWEEN 0 AND 100

    AND TRY_CAST(s.TotalAmountGBP AS DECIMAL(18,2)) >= 0

    AND s.Region IS NOT NULL
    AND LTRIM(RTRIM(s.Region)) <> '';
