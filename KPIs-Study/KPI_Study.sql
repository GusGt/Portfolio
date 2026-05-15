Select *
From Portfolio_Prog..KPI_Procurement

--------------------------------------------------------------------------------

DROP TABLE IF EXISTS #AlphaInc
SELECT *
INTO #AlphaInc
FROM Portfolio_Prog..KPI_Procurement
WHERE Supplier = 'Alpha_Inc'

DROP TABLE IF EXISTS #BetaSupplies
SELECT *
INTO #BetaSupplies
FROM Portfolio_Prog..KPI_Procurement
WHERE Supplier = 'Beta_Supplies'

DROP TABLE IF EXISTS #GammaCo
SELECT *
INTO #GammaCo
FROM Portfolio_Prog..KPI_Procurement
WHERE Supplier = 'Gamma_Co'

DROP TABLE IF EXISTS #DeltaLog
SELECT *
INTO #DeltaLog
FROM Portfolio_Prog..KPI_Procurement
WHERE Supplier = 'Delta_Logistics'

DROP TABLE IF EXISTS #EpsilonGroup
SELECT *
INTO #EpsilonGroup
FROM Portfolio_Prog..KPI_Procurement
WHERE Supplier = 'Epsilon_Group'

SELECT *
FROM #AlphaInc
SELECT *
FROM #BetaSupplies
SELECT *
FROM #GammaCo
SELECT *
FROM #DeltaLog
SELECT *
FROM #EpsilonGroup

--Above is the separation and organization of each Supplier within the data
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

WITH valueSaved (Supplier, sumUnit, sumNegotiated) 
AS (
Select Supplier, SUM(Unit_Price), SUM(Negotiated_Price)  --Discovered this is not actual price just base unit price across rows
FROM Portfolio_Prog..KPI_Procurement
Group by Supplier
)
Select Supplier, sumUnit, sumNegotiated, (sumUnit - sumNegotiated) AS sumSaved
FROM valueSaved

--Depciting the total costs/deals given by each supplier at base value, Sparks a new question regarding whether or not price matches a fair value for the amount of units bought

SELECT Supplier, Quantity, Unit_Price, Negotiated_Price, Quantity * Unit_Price as totalPrice, Quantity * Negotiated_Price as actualPrice
FROM #AlphaInc -- This is the true actual price we are searching for to find total costs

--------------------------------------------------------------------------------
WITH actualSaved (Supplier, Quantity, unitPrice, negPrice, totalPrice, actualPrice)
AS (
Select Supplier, Quantity, Unit_Price, Negotiated_Price, Quantity * Unit_Price, Quantity * Negotiated_Price
FROM Portfolio_Prog..KPI_Procurement
)
Select Supplier, SUM(Quantity) as Quantity, SUM(totalPrice) AS total, SUM(actualPrice) as actual 
FROM actualSaved
Group by Supplier
--Depicts the true amount of money spent showing millions of dollars in negotiations/costs by each supplier

--Poses the question of a suppliers reliability in terms of product arrving quickly


--------------------------------------------------------------------------------
SELECT Order_Date, Delivery_Date, DATEDIFF(day, Order_Date, Delivery_Date) AS timeTaken
FROM #AlphaInc
--base viewing of per order

SELECT Supplier, SUM(DATEDIFF(day, Order_Date, Delivery_Date))/COUNT(Supplier) AS averageDaysTaken
FROM Portfolio_Prog..KPI_Procurement
Group by Supplier
--shows on average how many days it takes for an order to be completed, 8 days for alpha


---------------------------------------------------------------------------------

SELECT
	DATETRUNC(month, Order_Date) as monthlyOrders, SUM(Quantity) as MonthlyAmount
FROM #AlphaInc
Group by DATETRUNC(month, Order_Date)

SELECT
	DATETRUNC(month, Order_Date) as monthlyOrders, SUM(Quantity) as MonthlyAmount
FROM #BetaSupplies
Group by DATETRUNC(month, Order_Date)

SELECT
	DATETRUNC(month, Order_Date) as monthlyOrders, SUM(Quantity) as MonthlyAmount
FROM #GammaCo
Group by DATETRUNC(month, Order_Date)

SELECT
	DATETRUNC(month, Order_Date) as monthlyOrders, SUM(Quantity) as MonthlyAmount
FROM #DeltaLog
Group by DATETRUNC(month, Order_Date)

SELECT
	DATETRUNC(month, Order_Date) as monthlyOrders, SUM(Quantity) as MonthlyAmount
FROM #EpsilonGroup
Group by DATETRUNC(month, Order_Date)

--Section depicts monthly amounts bought, further analysis should involve monthly amount spent
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
WITH monthlyCost (orderDate, Quantity,  totalPrice, actualPrice)
AS (
Select Order_Date, Quantity, Quantity * Unit_Price, Quantity * Negotiated_Price
FROM #AlphaInc
)
Select DATETRUNC(month, orderDate) as monthlyOrders, SUM(Quantity) as Quantity, SUM(totalPrice) AS totalPrice, SUM(actualPrice) as actualPrice 
FROM monthlyCost
Group by DATETRUNC(month, orderDate)


WITH monthlyCost (orderDate, Quantity,  totalPrice, actualPrice)
AS (
Select Order_Date, Quantity, Quantity * Unit_Price, Quantity * Negotiated_Price
FROM #BetaSupplies
)
Select DATETRUNC(month, orderDate) as monthlyOrders, SUM(Quantity) as Quantity, SUM(totalPrice) AS totalPrice, SUM(actualPrice) as actualPrice 
FROM monthlyCost
Group by DATETRUNC(month, orderDate)


WITH monthlyCost (orderDate, Quantity,  totalPrice, actualPrice)
AS (
Select Order_Date, Quantity, Quantity * Unit_Price, Quantity * Negotiated_Price
FROM #GammaCo
)
Select DATETRUNC(month, orderDate) as monthlyOrders, SUM(Quantity) as Quantity, SUM(totalPrice) AS totalPrice, SUM(actualPrice) as actualPrice 
FROM monthlyCost
Group by DATETRUNC(month, orderDate)


WITH monthlyCost (orderDate, Quantity,  totalPrice, actualPrice)
AS (
Select Order_Date, Quantity, Quantity * Unit_Price, Quantity * Negotiated_Price
FROM #DeltaLog
)
Select DATETRUNC(month, orderDate) as monthlyOrders, SUM(Quantity) as Quantity, SUM(totalPrice) AS totalPrice, SUM(actualPrice) as actualPrice 
FROM monthlyCost
Group by DATETRUNC(month, orderDate)


WITH monthlyCost (orderDate, Quantity,  totalPrice, actualPrice)
AS (
Select Order_Date, Quantity, Quantity * Unit_Price, Quantity * Negotiated_Price
FROM #EpsilonGroup
)
Select DATETRUNC(month, orderDate) as monthlyOrders, SUM(Quantity) as Quantity, SUM(totalPrice) AS totalPrice, SUM(actualPrice) as actualPrice 
FROM monthlyCost
Group by DATETRUNC(month, orderDate)
--Section depicts the full monthly costs from each supplier along with the total quantity purchased. Actual Price paid compared to total price before any negotiations
--------------------------------------------------------------------------------

WITH monthlyCost (Supplier, orderDate, Quantity,  totalPrice, actualPrice)
AS (
Select Supplier, Order_Date, Quantity, Quantity * Unit_Price, Quantity * Negotiated_Price
FROM Portfolio_Prog..KPI_Procurement
)
Select Supplier, DATETRUNC(month, orderDate) as monthlyOrders, SUM(Quantity) as Quantity,
SUM(totalPrice) AS totalPrice, SUM(actualPrice) as actualPrice,
SUM(actualPrice) - LAG(SUM(actualPrice)) OVER (PARTITION BY Supplier ORDER BY DATETRUNC(month, orderDate)) as monthDiff
FROM monthlyCost
Group by Supplier, DATETRUNC(month, orderDate)

--Depicts a more code condensed form showing all suppliers and their monthly costs in one table

--------------------------------------------------------------------------------

--Reliability is always an important aspect of suppliers, defective products is a loss

Select Supplier, SUM(Defective_Units) AS Defective_Units
FROM Portfolio_Prog..KPI_Procurement
Group by Supplier
-- Checks the # of defective products per supplier
--Gamma:7034
--Alpha:2717
--Beta:13838
--Delta:19678
--Epsilon:4682

Select Supplier, SUM(Quantity) as Quantity, SUM(Defective_Units) AS defective, SUM(Negotiated_Price * Defective_Units) as totalLoss
FROM Portfolio_Prog..KPI_Procurement
GROUP BY Supplier
-- Checks the total loss from defective products per supplier
--Gamma:388810.328884125
--Alpha:140060.800990105
--Beta:759467.468440056
--Delta:1025130.00756836
--Epsilon:254528.11964035

--Delta reaching over a million dollars in caused losses in this timespan's data

--------------------------------------------------------------------------------

--Beginning of more in-depth logistics regarding type of item purchased
Select Supplier, item_Category, SUM (Defective_Units) as defective
FROM Portfolio_Prog..KPI_Procurement
GROUP BY Supplier, Item_Category
ORDER BY Supplier

WITH actualSaved (Supplier, Item, Quantity, unitPrice, negPrice, totalPrice, actualPrice)
AS (
Select Supplier, Item_Category, Quantity, Unit_Price, Negotiated_Price, Quantity * Unit_Price, Quantity * Negotiated_Price
FROM Portfolio_Prog..KPI_Procurement
)
Select Supplier, Item, SUM(Quantity) as Quantity, SUM(totalPrice) AS total, SUM(actualPrice) as actual 
FROM actualSaved
Group by Supplier, Item
ORDER BY Supplier
