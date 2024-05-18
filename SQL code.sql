-- 1) How many customers has Foodie-Fi ever had?

Select  
  Count(Distinct customer_id) as total_customers
From subscriptions;


-- 2) What is the monthly distribution of trial plan start_date values for our dataset use the start of the month as the group by value.

Select 
  monthname(start_date) as month, 
  count(customer_id) as total_customers 
From subscriptions
Where plan_id = 0 
Group By month(start_date) 
Order by month(start_date);



-- 3) What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name.

Select 
  p.plan_name, 
  Count(s.customer_id) as total_customers
From plans as p
Join subscriptions as s ON p.plan_id = s.plan_id
Where year(start_date) <> 2020
Group by p.plan_name
Order by p.plan_id;


-- 4) What is the customer count and percentage of customers who have churned rounded to 1 decimal place?

-- # 1st Method - Subquery

  SELECT 
    customer_churned,
    Concat(ROUND((customer_churned / total_customer) * 100, 1),'%') AS churned_percentage
  FROM (
      SELECT (SELECT COUNT(s.customer_id)
          FROM plans AS p
          JOIN subscriptions s ON p.plan_id = s.plan_id
          WHERE p.plan_id = 4) AS customer_churned,
            (SELECT COUNT(DISTINCT s.customer_id)
             FROM plans AS p
             JOIN subscriptions s ON p.plan_id = s.plan_id) AS total_customer
  ) AS x;


-- # 2nd Method - CTE

  With churned_customers AS (
      select 
        p.plan_name, count(s.customer_id) as churned_customer
      From plans as p
      JOIN subscriptions s ON p.plan_id = s.plan_id
      Where p.plan_id = 4 ),
    
  total_customers AS (
      select 
        p.plan_name, count(Distinct s.customer_id) as total_customer
      From plans as p
      JOIN subscriptions s ON p.plan_id = s.plan_id)
      
  Select churned_customer,
      Concat(ROUND((churned_customer/ total_customer) *100,1),'%') As Churned_percentage
  FROM churned_customers as c
  Cross Join total_customers;
    


-- 5) How many customers have churned straight after their initial free trial. what percentage is this rounded to the nearest whole number?
    
  WITH churn_customer AS (
      SELECT *
      FROM (  
        SELECT s.*,p.plan_name, Row_number() Over (Partition by customer_id Order by start_date) AS rn
        FROM subscriptions AS s
        JOIN plans as p ON s.plan_id = p.plan_id ) as t
        WHERE rn = 2 AND plan_name ="Churn" )
      
  Select 
    Count(*) as churned_customer_after_trial,
    Concat(Round(Count(*) / (Select Count(Distinct customer_id) From subscriptions) *100,0),'%') As churned_percentage
  From churn_customer;


-- # Without Join

WITH CTE AS (
    SELECT *
    FROM (  
      SELECT *, ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY start_date) AS rn
      FROM subscriptions ) as t
      WHERE rn = 2 AND plan_id =4)
        
Select count(*) as churned_customer_after_trial,
Round(Count(*) / (Select COUNT(Distinct customer_id) From subscriptions) *100,0) As churned_percentage
From CTE;


--  6.  What is the number and percentage of customer plans after their initial free trial?

   WITH CTE AS (
  Select 
    customer_id, plan_name, 
    Row_number () Over (Partition by customer_id Order by start_date) as rn
  From subscriptions as s
  Join plans as p ON s.plan_id = p.plan_id) 

  Select 
    plan_name, count(*) as customer_after_trial,
    Concat(Round( count(*) / (Select Count(Distinct customer_id) From cte)*100,2),'%') as percentage
  From CTE
  Where rn = 2 
  Group by plan_name;


--  7.  What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?

 WITH CTE AS (
  Select *, 
    Row_number() Over (Partition by customer_id Order by start_date desc) As rn
  From subscriptions
  Where start_date <= "2020-12-31")
    
  Select 
    plan_name , Count(customer_id) as customer,
    Concat(Round(Count(customer_id)/(Select Count(Distinct customer_id) From CTE)*100,1),'%') as percentage
  From CTE
  JOIN plans as p ON CTE.plan_id = p.plan_id
  Where rn = 1
  Group by p.plan_id;
   

-- 8. How many customers have upgraded to an annual plan in 2020?

  WITH monthly_customers AS (
    SELECT  
       customer_id, start_date
    FROM subscriptions as S
    WHERE year(start_date) = 2020 AND plan_id IN (1,2)
    ),
    
  annual_customers AS (
    SELECT 
       customer_id, start_date
    FROM subscriptions as S
    WHERE year (start_date) = 2020 AND plan_id = 3
  )

  SELECT 
    Count(DISTINCT A.customer_id) as annual_upgrade_customers
  FROM monthly_customers as M
  INNER JOIN annual_customers as A 
    ON M.customer_id = A.customer_id AND M.start_date < A.start_date;


-- 9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?

  WITH first_plan AS (
    Select *, row_number() over (partition by customer_id order by start_date) as rn
    From subscriptions
    Where plan_id = 0),

  pro_annual_plan AS ( 
    Select * , row_number() over (partition by customer_id order by start_date) as rn
    From subscriptions
    Where plan_id = 3)

  Select Round(AVG(Datediff(p.start_date, f.start_date)),0) as avg_upgradation_day_to_pro_annual
  From first_plan as f
  JOIN pro_annual_plan as p ON f.customer_id = p.customer_id
  Where f.start_date < p.start_date;
    
    

-- 10.   Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)

-- # 1st short method

  WITH Trial as (
    SELECT customer_id, start_date as trial_start
    FROM subscriptions
    WHERE plan_id = 0 ),
    
  Annual as (
    SELECT customer_id, start_date as annual_start
    FROM subscriptions
    WHERE plan_id = 3 )
    
  SELECT 
    CONCAT(
      FLOOR((DATEDIFF(A.annual_start, T.trial_start) - 1) / 30) * 30 + 1, 
      '-', 
      FLOOR((DATEDIFF(A.annual_start, T.trial_start) - 1) / 30) * 30 + 30
        ) as days_duration,
    COUNT(T.customer_id) as customer_count
  FROM Trial AS T
  INNER JOIN Annual as A ON T.customer_id = A.customer_id
  GROUP BY 1;


-- # 2nd Method

WITH TRIAL AS (
SELECT 
customer_id,
start_date as trial_start
FROM subscriptions
WHERE plan_id = 0
)
, ANNUAL AS (
SELECT 
customer_id,
start_date as annual_start
FROM subscriptions
WHERE plan_id = 3
)
SELECT 
  CASE
    WHEN DATEDIFF(annual_start, trial_start) <= 30 THEN '0-30'
    WHEN DATEDIFF(annual_start, trial_start) <= 60 THEN '31-60'
    WHEN DATEDIFF(annual_start, trial_start) <= 90 THEN '61-90'
    WHEN DATEDIFF(annual_start, trial_start) <= 120 THEN '91-120'
    WHEN DATEDIFF(annual_start, trial_start) <= 150 THEN '121-150'
    WHEN DATEDIFF(annual_start, trial_start) <= 180 THEN '151-180'
    WHEN DATEDIFF(annual_start, trial_start) <= 210 THEN '181-210'
    WHEN DATEDIFF(annual_start, trial_start) <= 240 THEN '211-240'
    WHEN DATEDIFF(annual_start, trial_start) <= 270 THEN '241-270'
    WHEN DATEDIFF(annual_start, trial_start) <= 300 THEN '271-300'
    WHEN DATEDIFF(annual_start, trial_start) <= 330 THEN '301-330'
    WHEN DATEDIFF(annual_start, trial_start) <= 360 THEN '331-360'
  END AS bin,

COUNT(T.customer_id) as customer_count
FROM TRIAL as T
INNER JOIN ANNUAL as A on T.customer_id = A.customer_id
GROUP BY 1;


-- 11.How many customers downgraded from a pro monthly to a basic monthly plan in 2020?

  WITH pro_monthly_plan AS (
        Select * 
        From subscriptions
        Where year(start_date) = 2020 And plan_id =2),

  basic_monthly_plan AS (
        Select * from subscriptions
        Where year(start_date) = 2020 AND plan_id =1)

  Select count(Distinct b.customer_id) as customers_downgraded
  From pro_monthly_plan as p
  JOIN basic_monthly_plan as b
    ON p.customer_id = b.customer_id
  Where p.start_date < b.start_date;

