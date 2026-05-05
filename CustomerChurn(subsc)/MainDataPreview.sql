Select *
From Portfolio_Prog..customerChurn
-- ~10k lines of raw data depicting the amount of monthly spending and whether or not the customer stayed or left

Select *
From Portfolio_Prog..customerChurn
Where Age is not null
Order by Age ASC
-- Removing all null ages, also shows that we have some negative numbers for age, such innacuracies hinders the data

