
CREATE OR ALTER VIEW dbo.vw_retail_sales_staging
AS
SELECT
    TransactionID,
    TransactionDate,
    CustomerID,
    ProductID,
    Category,
    Quantity,
    UnitPriceGBP,
    DiscountPercent,
    PaymentMethod,
    SalesChannel,
    Region,
    TotalAmountGBP
FROM OPENROWSET(
    BULK 'retail-project/staging/retail_sales_staging.csv',
    DATA_SOURCE = 'RetailDataLake',
    FORMAT = 'CSV',
    PARSER_VERSION = '2.0',
    FIRSTROW = 2
)
WITH (
    TransactionID VARCHAR(50) COLLATE Latin1_General_100_BIN2_UTF8,
    TransactionDate VARCHAR(50) COLLATE Latin1_General_100_BIN2_UTF8,
    CustomerID VARCHAR(50) COLLATE Latin1_General_100_BIN2_UTF8,
    ProductID VARCHAR(50) COLLATE Latin1_General_100_BIN2_UTF8,
    Category VARCHAR(100) COLLATE Latin1_General_100_BIN2_UTF8,
    Quantity VARCHAR(50) COLLATE Latin1_General_100_BIN2_UTF8,
    UnitPriceGBP VARCHAR(50) COLLATE Latin1_General_100_BIN2_UTF8,
    DiscountPercent VARCHAR(50) COLLATE Latin1_General_100_BIN2_UTF8,
    PaymentMethod VARCHAR(100) COLLATE Latin1_General_100_BIN2_UTF8,
    SalesChannel VARCHAR(100) COLLATE Latin1_General_100_BIN2_UTF8,
    Region VARCHAR(100) COLLATE Latin1_General_100_BIN2_UTF8,
    TotalAmountGBP VARCHAR(50) COLLATE Latin1_General_100_BIN2_UTF8
) AS sales;
