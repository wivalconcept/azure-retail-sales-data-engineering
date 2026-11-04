
-- ============================================================
-- Project: Azure Retail Sales Data Engineering
-- Script: 03_retail_sales_rejected.sql
-- Purpose: Identify invalid and duplicate retail sales
-- Platform: Azure Synapse Analytics - Serverless SQL
--
-- Validation checks:
-- 1. Missing transaction IDs
-- 2. Conflicting/duplicate transaction IDs
-- 3. Missing customer IDs
-- 4. Invalid transaction dates
-- 5. Invalid quantities
-- 6. Invalid unit prices
-- 7. Invalid discount percentages
-- 8. Invalid transaction amounts
-- 9. Missing sales regions
--
-- Classification:
-- QUARANTINE - Duplicate/conflicting transaction IDs
-- REJECTED   - Other validation failures
--
-- Note: Records with duplicate IDs take priority for
-- QUARANTINE classification, even if other rules fail.
-- ============================================================

CREATE OR ALTER VIEW dbo.vw_retail_sales_rejected
AS

WITH DuplicateCheck AS (
    SELECT
        TransactionID,
        COUNT(*) AS TransactionCount
    FROM dbo.vw_retail_sales_staging
    GROUP BY TransactionID
),

ValidatedSales AS (
    SELECT
        s.*,

        -- Generate descriptive rejection reasons.
        -- Multiple reasons may be assigned to one record.

        CASE
            WHEN s.TransactionID IS NULL
              OR LTRIM(RTRIM(s.TransactionID)) = ''
            THEN 'Missing Transaction ID; ' ELSE ''
        END

        +

        CASE
            WHEN d.TransactionCount > 1
            THEN 'Conflicting Transaction ID; ' ELSE ''
        END

        +

        CASE
            WHEN s.CustomerID IS NULL
              OR LTRIM(RTRIM(s.CustomerID)) = ''
            THEN 'Missing Customer ID; ' ELSE ''
        END

        +

        CASE
            WHEN TRY_CAST(s.TransactionDate AS DATE) IS NULL
            THEN 'Invalid Date; ' ELSE ''
        END

        +

        CASE
            WHEN TRY_CAST(s.Quantity AS INT) IS NULL
              OR TRY_CAST(s.Quantity AS INT) <= 0
            THEN 'Invalid Quantity; ' ELSE ''
        END

        +

        CASE
            WHEN TRY_CAST(s.UnitPriceGBP AS DECIMAL(18,2)) IS NULL
              OR TRY_CAST(s.UnitPriceGBP AS DECIMAL(18,2)) < 0
            THEN 'Invalid Price; ' ELSE ''
        END

        +

        CASE
            WHEN TRY_CAST(s.DiscountPercent AS DECIMAL(5,2))
                 NOT BETWEEN 0 AND 100
              OR TRY_CAST(s.DiscountPercent AS DECIMAL(5,2)) IS NULL
            THEN 'Invalid Discount; ' ELSE ''
        END

        +

        CASE
            WHEN TRY_CAST(s.TotalAmountGBP AS DECIMAL(18,2)) IS NULL
              OR TRY_CAST(s.TotalAmountGBP AS DECIMAL(18,2)) < 0
            THEN 'Invalid Total Amount; ' ELSE ''
        END

        +

        CASE
            WHEN s.Region IS NULL
              OR LTRIM(RTRIM(s.Region)) = ''
            THEN 'Missing Region; ' ELSE ''
        END

        AS RejectionReason

    FROM dbo.vw_retail_sales_staging AS s

    LEFT JOIN DuplicateCheck AS d
        ON s.TransactionID = d.TransactionID
)

SELECT
    *,

    -- Prioritise duplicate transactions for quarantine.
    CASE
        WHEN RejectionReason LIKE '%Conflicting Transaction ID%'
        THEN 'QUARANTINE'
        ELSE 'REJECTED'
    END AS RecordStatus

FROM ValidatedSales

-- Return only records that failed validation.
WHERE RejectionReason <> '';
