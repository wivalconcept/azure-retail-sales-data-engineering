
-- ============================================================
-- Project: Azure Retail Sales Data Engineering
-- Script: 09_revenue_by_payment_method.sql
-- Purpose: Analyse retail revenue by payment method
-- Platform: Azure Synapse Analytics - Serverless SQL
--
-- Business metrics:
-- 1. Total transactions by payment method
-- 2. Total units sold by payment method
-- 3. Total revenue in GBP
-- 4. Average transaction value in GBP
--
-- Source: dbo.vw_retail_sales_clean
-- ============================================================

-- STEP 1: Create the payment method analytics view

CREATE OR ALTER VIEW dbo.vw_revenue_by_payment_method
AS
SELECT
    -- Identify the payment method used
    PaymentMethod,

    -- Count transactions for each payment method
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

GROUP BY PaymentMethod;
