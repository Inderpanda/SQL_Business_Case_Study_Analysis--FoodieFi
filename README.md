# Overview
Danny saw a market gap and launched Foodie-Fi , a streaming service exclusively for food-related content, similar to Netflix but focused on cooking shows. 

With the help of a few smart friends, he offered monthly and annual subscriptions, providing unlimited access to exclusive global food videos.

 Committed to data-driven decision-making, Danny ensured that all future investments and feature developments for Foodie-Fi would be guided by detailed analysis of subscription data. 

This case study explores how subscription data can be leveraged to answer key business questions for the growth and improvement of Foodie-Fi.



![Screenshot (4976) - Copy](https://github.com/Inderpanda/SQL_Business_Case_Study_Analysis--FoodieFi/assets/138003751/9bf7aa4d-90fb-4824-8089-d4910295dd97)


# Table 1 : plans

Customers can choose which plans to join Foodie-Fi when they first sign up.

Basic plan customers have limited access and can only stream their videos and is only available monthly at $9.90

Pro plan customers have no watch time limits and are able to download videos for offline viewing. Pro plans start at $19.90 a month or $199 for an annual subscription.

Customers can sign up to an initial 7 day free trial will automatically continue with the pro monthly subscription plan unless they cancel, downgrade to basic or upgrade to an annual pro plan at any point during the trial.

When customers cancel their Foodie-Fi service - they will have a churn plan record with a null price but their plan will continue until the end of the billing period.

# Table 2 : subscriptions

Customer subscriptions show the exact date where their specific plan_id starts.

If customers downgrade from a pro plan or cancel their subscription - the higher plan will remain in place until the period is over - the start_date in the subscriptions table will reflect the date that the actual plan changes.

When customers upgrade their account from a basic plan to a pro or annual pro plan - the higher plan will take effect straightaway.

When customers churn - they will keep their access until the end of their current billing period but the start_date will be technically the day they decided to cancel their service.


# Analysis Questions

![Screenshot (4980)](https://github.com/Inderpanda/SQL_Business_Case_Study_Analysis--FoodieFi/assets/138003751/b7df37f8-1651-43e3-bad6-da23d774bc78)

![Screenshot (5006)](https://github.com/Inderpanda/SQL_Business_Case_Study_Analysis--FoodieFi/assets/138003751/7cac50da-0a44-4770-a16d-a77e9253dc6a)


# Business Questions 

![Box Q](https://github.com/Inderpanda/SQL_Business_Case_Study_Analysis--FoodieFi/assets/138003751/6257f7ae-4d7f-4cb2-abe5-1e595325b3ad)

![Screenshot (5007)](https://github.com/Inderpanda/SQL_Business_Case_Study_Analysis--FoodieFi/assets/138003751/b44a3598-34f3-4cfa-b444-09cabda9b27c)


# Conclusion

This project demonstrated the power of data-driven decision-making in a subscription-based business. My contribution involved performing detailed SQL analyses, deriving actionable insights, and providing strategic recommendations to drive business growth and improve customer retention at Foodie-Fi.







