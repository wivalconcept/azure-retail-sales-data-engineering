
-- ============================================================
-- Project: Azure Retail Sales Data Engineering
-- Script: 12_retail_customers_staging.sql
-- Purpose: Create a staging view for retail customer data
-- Platform: Azure Synapse Analytics - Serverless SQL
--
-- Data source: Azure Data Lake Storage Gen2
-- External data source: RetailDataLake
-- File: retail-project/staging/retail_customers_staging.csv
--
-- Customer attributes:
-- 1. Customer ID
-- 2. Customer segment
-- 3. Customer region
-- 4. Signup date
-- 5. Loyalty tier
--
-- Downstream usage:
-- Customer enrichment and customer analytics
-- ============================================================

-- STEP 1: Create the customer staging view

CREATE OR ALTER VIEW dbo.vw_retail_customers_staging
AS
SELECT
    -- Unique customer identifier
    CustomerID,

    -- Customer classification
    CustomerSegment,

    -- Customer geographical region
    Region,

    -- Convert signup date to SQL DATE
    TRY_CAST(SignupDate AS DATE) AS SignupDate,

    -- Customer loyalty classification
    LoyaltyTier

FROM OPENROWSET(
    BULK 'retail-project/staging/retail_customers_staging.csv',
    DATA_SOURCE = 'RetailDataLake',
    FORMAT = 'CSV',
    PARSER_VERSION = '2.0',
    HEADER_ROW = TRUE
)

-- Define the schema of the incoming CSV file
WITH (
    CustomerID VARCHAR(50),
    CustomerSegment VARCHAR(100),
    Region VARCHAR(100),
    SignupDate VARCHAR(50),
    LoyaltyTier VARCHAR(50)
) AS customers;
