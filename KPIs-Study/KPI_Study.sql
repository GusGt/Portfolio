Select *
From Portfolio_Prog..KPI_Procurement

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