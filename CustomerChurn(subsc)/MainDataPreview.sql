Select *
From Portfolio_Prog..customerChurn
-- ~10k lines of raw data depicting the amount of monthly spending and whether or not the customer stayed or left

Select *
From Portfolio_Prog..customerChurn
Where Age is not null
Order by Age ASC
-- Removing all null ages, also shows that we have some negative numbers for age, such innacuracies hinders the data
--Where Age is not null AND age > 0

Select Gender, Count(Customer_Service_Calls) as CCS
From Portfolio_Prog..customerChurn
Group by Gender
--Shows # of calls ragarding each gender recorded

Select Gender, COUNT(Monthly_Spend) as MS
From Portfolio_Prog..customerChurn
Group by Gender
--Shows which gender spends the most money, (nothing of note for this data)

Select Subscription_Plan, Count(Customer_Service_Calls) as CCS
From Portfolio_Prog..customerChurn
Group by Subscription_Plan
--Shows # of calls ragarding each type of subscription plan recorded
--Depicts that the Basic plan customers are the ones running into the most issues causing more calls than the other plans

SELECT 
    FLOOR(Age / 10) * 10 AS age_bracket,
    COUNT(Monthly_Spend)
FROM Portfolio_Prog..customerChurn
Where Age is not null AND Age > 0
GROUP BY FLOOR(Age / 10) * 10
Order by age_bracket ASC
--Depicts the most active cusomters, Here showing that this buisness' analytics are mostly within the 20-49 age range

SELECT 
    FLOOR(Age / 10) * 10 AS age_bracket,
    Count(Churn)
FROM Portfolio_Prog..customerChurn
Where Age is not null AND Age > 0
GROUP BY FLOOR(Age / 10) * 10
Order by age_bracket ASC

Select 
    FLOOR(Age / 10) * 10 AS age_bracket,
    AVG(CONVERT(float, Churn)) * 100 as ChurnRate
From Portfolio_Prog..customerChurn
GROUP BY FLOOR(Age / 10) * 10
Order by age_bracket ASC
--Depicts rate of customer churn at each age range, Within this data set churn rate is high among all age ranges

Select 
    FLOOR(Days_Since_Last_Login / 10) * 10 AS DaysOff,
    AVG(CONVERT(float, Churn)) * 100 as ChurnRate
From Portfolio_Prog..customerChurn
GROUP BY FLOOR(Days_Since_Last_Login / 10) * 10
Order by DaysOff ASC
--Depicts churn rate in regards to the amount of days since customer has last logged into website

Select
    COUNT(Subscription_Plan) as Subscriptions,
    FLOOR(Age / 10) * 10 AS age_bracket
From Portfolio_Prog..customerChurn
Where Age is not null AND Age > 0
GROUP BY FLOOR(Age / 10) * 10
Order by age_bracket ASC

Select Subscription_Plan as Subscriptions, SUM(Monthly_Spend) as Ms
From Portfolio_Prog..customerChurn
Group by Subscription_Plan
--Depicts that the most money for this service comes from the Basic plan members

Select 
    Subscription_Plan,
    AVG(CONVERT(float, Churn)) * 100 as ChurnRate
From Portfolio_Prog..customerChurn
Group by Subscription_Plan
--Shows churn rate among types of plan, showing that the basic plan has the highest churn rate, showing loyalty mostly among Plus members

Select  
        Region,
        COUNT(CASE WHEN Subscription_Plan = 'Basic' then 1 END) as Basic,
        COUNT(CASE WHEN Subscription_Plan = 'Pro' then 1 END) as Pro,
        COUNT(CASE WHEN Subscription_Plan = 'Plus' then 1 END) as Plus
From Portfolio_Prog..customerChurn 
Group by Region
--Depicts regional information regarding types of plans allowing for the clarification on whether or not advertisement can be increased in a specific region. (this data shows an even split among the regions)



--Views for vizualizations--

Create VIEW RegionalAnayltics as
Select  
        Region,
        COUNT(CASE WHEN Subscription_Plan = 'Basic' then 1 END) as Basic,
        COUNT(CASE WHEN Subscription_Plan = 'Pro' then 1 END) as Pro,
        COUNT(CASE WHEN Subscription_Plan = 'Plus' then 1 END) as Plus
From Portfolio_Prog..customerChurn 
Group by Region

Create VIEW TotalPlans as
Select Subscription_Plan, Count(Customer_Service_Calls) as CCS
From Portfolio_Prog..customerChurn
Group by Subscription_Plan


