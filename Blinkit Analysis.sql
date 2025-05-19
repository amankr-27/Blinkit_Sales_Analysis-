CREATE TABLE Blinkit(
    ItemFatContent VARCHAR(20),
    ItemIdentifier VARCHAR(20),
    ItemType VARCHAR(50),
    OutletEstablishmentYear INT,
    OutletIdentifier VARCHAR(20),
    OutletLocationType VARCHAR(20),
    OutletSize VARCHAR(20),
    OutletType VARCHAR(30),
    ItemVisibility DECIMAL(10,6),
    ItemWeight DECIMAL(10,2) NULL,
    Sales DECIMAL(10,4),
    Rating DECIMAL(3,1)
);


-- Sample
SELECT 
    *
FROM
    blinkit;



-- Data Cleaning 
SET SQL_SAFE_UPDATES = 0;

UPDATE blinkit 
SET 
    ItemFatContent = CASE
        WHEN ItemFatContent IN ('LF' , 'low fat') THEN 'Low Fat'
        WHEN ItemFatContent = 'reg' THEN 'Regular'
        ELSE ItemFatContent
    END
WHERE
    ItemFatContent IN ('LF' , 'low fat', 'reg');
    
SET SQL_SAFE_UPDATES = 1;  -- Re-enable safe mode after the update



-- Unnique item Fat Content 
SELECT DISTINCT
    (ItemFatContent)
FROM
    blinkit;
    
    
-- Total Sales 
SELECT 
    ROUND(SUM(sales), 0) AS 'Total_Sales'
FROM
    blinkit
WHERE
    OutletEstablishmentYear = 2022;


-- Avg Sales 
SELECT 
    ROUND(AVG(sales), 0) AS 'Avg_Sales'
FROM
    blinkit
WHERE
    OutletEstablishmentYear = 2022;


-- No of total items
SELECT 
    COUNT(*) AS 'No_of_items'
FROM
    blinkit
WHERE
    OutletEstablishmentYear = 2022;


-- Average Rating 
SELECT 
    ROUND(AVG(rating), 0) AS 'Avg_Rating'
FROM
    blinkit;
    
    
-- Item Fat Content Sales Analysis
SELECT 
    ItemFatContent,
    ROUND(SUM(sales), 2) AS 'Total_Sales',
    ROUND(AVG(sales), 2) AS 'Avg_Sales',
    COUNT(*) AS 'No_of_items',
    ROUND(AVG(rating), 2) AS 'Avg_Rating'
FROM
    blinkit
GROUP BY ItemFatContent
ORDER BY Total_Sales DESC;


-- Top 5 Item Type Sales Analysis
SELECT 
    ItemType,
    ROUND(SUM(sales), 2) AS 'Total_Sales',
    ROUND(AVG(sales), 2) AS 'Avg_Sales',
    COUNT(*) AS 'No_of_items',
    ROUND(AVG(rating), 2) AS 'Avg_Rating'
FROM
    blinkit
GROUP BY ItemType
ORDER BY Total_Sales DESC
limit 5;


-- Sales by Fat Content and Outlet Location
SELECT 
    OutletLocationType,
    ROUND(SUM(CASE
                WHEN ItemFatContent = 'Low Fat' THEN sales
                ELSE 0
            END),
            2) AS 'Low_Fat_Sales',
    ROUND(SUM(CASE
                WHEN ItemFatContent = 'Regular' THEN sales
                ELSE 0
            END),
            2) AS 'Regular_Sales'
FROM
    blinkit
GROUP BY OutletLocationType
ORDER BY OutletLocationType;


-- Total Sales by Outlet Establishment Year
SELECT 
    OutletEstablishmentYear,
    ROUND(SUM(sales), 2) AS 'Total_Sales',
    ROUND(AVG(sales), 2) AS 'Avg_Sales',
    COUNT(*) AS 'No_of_items',
    ROUND(AVG(rating), 2) AS 'Avg_Rating'
FROM
    blinkit
GROUP BY OutletEstablishmentYear
ORDER BY Total_Sales DESC


-- Total Sales and Percentage by Outlet Size
SELECT 
    OutletSize,
    ROUND(SUM(Sales), 2) AS TotalSales,
    ROUND((SUM(Sales) / (SELECT 
                    SUM(Sales)
                FROM
                    Blinkit)),
            2) * 100 AS SalesPercentage
FROM
    Blinkit
GROUP BY OutletSize;


-- Sales and Rating Summary by Outlet Location (2020)
SELECT 
    OutletLocationType,
    ROUND(SUM(Sales), 2) AS TotalSales,
    ROUND((SUM(Sales) / (SELECT 
                    SUM(Sales)
                FROM
                    Blinkit)),
            2) * 100 AS SalesPercentage,
    ROUND(AVG(sales), 2) AS 'Avg_Sales',
    COUNT(*) AS 'No_of_items',
    ROUND(AVG(rating), 2) AS 'Avg_Rating'
FROM
    Blinkit
WHERE
    OutletEstablishmentYear = 2020
GROUP BY OutletLocationType
ORDER BY TotalSales DESC;


-- Sales and Rating Summary by Outlet Type
SELECT 
    OutletType,
    ROUND(SUM(Sales), 2) AS TotalSales,
    ROUND((SUM(Sales) / (SELECT 
                    SUM(Sales)
                FROM
                    Blinkit)),
            2) * 100 AS SalesPercentage,
    ROUND(AVG(sales), 2) AS 'Avg_Sales',
    COUNT(*) AS 'No_of_items',
    ROUND(AVG(rating), 2) AS 'Avg_Rating'
FROM
    Blinkit
GROUP BY OutletType
ORDER BY TotalSales DESC;