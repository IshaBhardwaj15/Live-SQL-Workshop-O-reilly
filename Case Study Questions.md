# 💸 Cryptocurrency Case Study Questions

#### Basic Data Analysis Techniques:

1. Show only the top 5 rows from the trading.members table

optional questions:

- What is the region value for the 8th row?

- What is the member_id value for the 14th row?
    
2. Sort all the rows in the trading.members table by first_name in alphabetical order and show the top 3 rows with all columns

optional questions:

- What is the first_name value in the 1st row when you sort by region in alphabetical order?

- What is the region value in the 10th row when you sort by member_id in alphabetical order?

3. Count the number of records from the trading.members table which have United States as the region value

4. Select only the first_name and region columns for mentors who are not from Australia

5. Return only the unique region values from the trading.members table and sort the output by reverse alphabetical order

***

#### Aggregate functions for data analysis:

1. How many records are there per ticker value in the trading.prices table?

2. What is the maximum, minimum values for the price column for both Bitcoin and Ethereum in 2020?

3. What is the annual minimum, maximum and average price for each ticker?
- Include a calendar_year column with the year from 2017 through to 2021
- Calculate a spread column which calculates the difference between the min and max prices
- Round the average price output to 2 decimal places
- Sort the output in chronological order with Bitcoin records before Ethereum within each year

4. What is the monthly average of the price column for each ticker from January 2020 and after?
- Create a month_start column with the first day of each month
- Sort the output by ticker in alphabetical order and months in chronological order
- Round the average_price column to 2 decimal places

***

#### Understanding CASE WHEN Statements:

1. Convert the volume column in the trading.prices table with an adjusted integer value to take into the unit values
- Return only the market_date, price, volume and adjusted_volume columns for the first 10 days of August 2021 for Ethereum only

2.  How many "breakout" days were there in 2020 where the price column is greater than the open column for each ticker?
- In the same query also calculate the number of "non breakout" days where the price column was lower than or equal to the open column

3.  What was the final quantity Bitcoin and Ethereum held by all Data With Danny mentors based off the trading.transactions table?

***

#### Operating Windows functions:

1. What are the market_date, price and volume and price_rank values for the days with the top 5 highest price values for each 
- tickers in the trading.prices table? The price_rank column is the ranking for price values for each ticker with rank = 1 for the highest value.
- Return the output for Bitcoin, followed by Ethereum in price rank order.

2. Calculate a 7 day rolling average for the price and volume columns in the trading.prices table for each ticker.
- Return only the first 10 days of August 2021

3. Calculate the monthly cumulative volume traded for each ticker in 2020
- Sort the output by ticker in chronological order with the month_start as the first day of each month

4. Calculate the daily percentage change in volume for each ticker in the trading.prices table
- Percentage change can be calculated as (current - previous) / previous
- Multiply the percentage by 100 and round the value to 2 decimal places
- Return data for the first 10 days of August 2021

***

#### Using Table Joins:

1. Which top 3 mentors have the most Bitcoin quantity? Return the first_name of the mentors and sort the output from highest to lowest total_quantity

2. Show the market_date values which have less than 5 transactions? Sort the output in reverse chronological order.

3. For this question - we will generate a single table output which solves a multi-part problem about the dollar cost average of BTC purchases.

a. Part 1: Calculate the Dollar Cost Average

- What is the dollar cost average (btc_dca) for all Bitcoin purchases by region for each calendar year?
- Create a column called year_start and use the start of the calendar year
- The dollar cost average calculation is btc_dca = SUM(quantity x price) / SUM(quantity)

b. Part 2: Yearly Dollar Cost Average Ranking

- Use this btc_dca value to generate a dca_ranking column for each year
- The region with the lowest btc_dca each year has a rank of 1

c. Part 3: Dollar Cost Average Yearly Percentage Change

- Calculate the yearly percentage change in DCA for each region to 2 decimal places
- This calculation is (current - previous) / previous
- Finally order the output by region and year_start columns

***
