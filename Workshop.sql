--1. Basic Data Analysis Techniques:

--Q1 Show only the top 5 rows from the trading.members table
select region from trading.members
limit 5;

--What is the region value for the 8th row?
select region from trading.members
limit 1 offset 7;

--What is the member_id value for the 14th row?
select member_id from trading.members
limit 1 offset 13;

--Q2 Sort all the rows in the trading.members table by first_name in alphabetical order and show the top 3 rows with all columns
select * from trading.members
order by first_name asc
limit 3;

--What is the first_name value in the 1st row when you sort by region in alphabetical order?
select first_name
from trading.members
order by region asc
limit 1;

--What is the region value in the 10th row when you sort by member_id in alphabetical order?
select region
from trading.members
order by member_id asc
limit 1 offset 9;

--Q3 Count the number of records from the trading.members table which have United States as the region value
select count(*) as no_of_records
from trading.members
where region='United States';

--Q4 Select only the first_name and region columns for mentors who are not from Australia
select first_name,region
from trading.members
where region<>'Australia';

--Q5 Return only the unique region values from the trading.members table and sort the output by reverse alphabetical order
select distinct(region) as Unique_region
from trading.members
order by Unique_region desc;


--2. Aggregate functions for data analysis:

--Q1 How many records are there per ticker value in the trading.prices table?
select ticker,count(*) as no_of_records
from trading.prices
group by ticker;

--Q2 What is the maximum, minimum values for the price column for both Bitcoin and Ethereum in 2020?
select ticker,min(price) as min_price,max(price) as max_price
from trading.prices
where date_part('year',market_date)=2020
group by ticker;

--Q3 What is the annual minimum, maximum and average price for each ticker?
--Include a calendar_year column with the year from 2017 through to 2021
--Calculate a spread column which calculates the difference between the min and max prices
--Round the average price output to 2 decimal places
--Sort the output in chronological order with Bitcoin records before Ethereum within each year
select date_part('year',market_date) as calendar_year,ticker,min(price) as min_price,max(price) as max_price,
  round(avg(price)::numeric,2) as avg_price,(max(price)-min(price)) as spread
from trading.prices
group by calendar_year,ticker
order by calendar_year,ticker;

--Q4 What is the monthly average of the price column for each ticker from January 2020 and after?
--Create a month_start column with the first day of each month
--Sort the output by ticker in alphabetical order and months in chronological order
--Round the average_price column to 2 decimal places
select date_trunc('month',market_date) as month_start, ticker,round(avg(price)::numeric,2) as avg_price
from trading.prices
where market_date>='2020-01-01'
group by ticker,month_start
order by ticker,month_start;

3. Understanding CASE WHEN Statements:

--Q1 Convert the volume column in the trading.prices table with an adjusted integer value to take into the unit values
--Return only the market_date, price, volume and adjusted_volume columns for the first 10 days of August 2021 for Ethereum only
select market_date,price,volume,
  case when right(volume,1)='K' then left(volume,LENGTH(volume)-1)::numeric*1000
       when right(volume,1)='M' then left(volume,LENGTH(volume)-1)::numeric*100000
       else 0
  end as adjusted_volume
from trading.prices
where market_date between '2021-08-01' and '2021-08-10' and ticker='ETH'
group by market_date,price,volume;

--Q2 How many "breakout" days were there in 2020 where the price column is greater than the open column for each ticker?
---In the same query also calculate the number of "non breakout" days where the price column was lower than or equal to the open column.
select ticker,
  sum(case when price>open then 1 else 0 end) as breadkout_days,
  sum(case when price<open then 1 else 0 end) as non_breakout_days
from trading.prices
where date_part('year',market_date)=2020
group by ticker;

--Q3 What was the final quantity Bitcoin and Ethereum held by all Data With Danny mentors based off the trading.transactions table?
select ticker,
  sum(case when txn_type='SELL' then -quantity else quantity end) as total_quantity
from trading.transactions
group by ticker;


--4. Operating Windows functions:

--Q1 What are the market_date, price and volume and price_rank values for the days with the top 5 highest price values for each 
--tickers in the trading.prices table? The price_rank column is the ranking for price values for each ticker with rank = 1 for the highest value.
--Return the output for Bitcoin, followed by Ethereum in price rank order.
with cte as
(
  select ticker,market_date,price,volume,
    rank() over(partition by ticker order by price desc) as price_rank
  from trading.prices
  group by ticker,market_date,price,volume
  order by ticker
)
select * from cte
where price_rank<=5
group by ticker,market_date,price,volume,price_rank
order by ticker,price desc;

--Q2 Calculate a 7 day rolling average for the price and volume columns in the trading.prices table for each ticker.
--Return only the first 10 days of August 2021
with volume as
(
  select ticker,market_date,price,
    case when right(volume,1)='K' then left(volume,LENGTH(volume)-1)::numeric*1000
         when right(volume,1)='M' then left(volume,LENGTH(volume)-1)::numeric*1000000
         else 0
    end as new_volume
  from trading.prices
  where market_date between '2021-08-01' and '2021-08-10'
  group by ticker,market_date,price,new_volume
),
moving_avg_price as
(
  select ticker,market_date,new_volume,price,
    avg(price) over(partition by ticker order by market_date range between '7 DAYS' preceding and current row)
    as moving_avg_price
  from volume
  group by ticker,market_date,price,new_volume,price
)
select ticker,market_date,moving_avg_price,new_volume,
  avg(new_volume) over(partition by ticker order by market_date range between '7 DAYS' preceding and current row)
    as moving_avg_volume
from moving_avg_price
group by ticker,market_date,moving_avg_price,new_volume;

--Q3 Calculate the monthly cumulative volume traded for each ticker in 2020
--Sort the output by ticker in chronological order with the month_start as the first day of each month
with cte as
(
  select ticker,date_trunc('month',market_date) as month_start,
    sum(case when right(volume,1)='K' then left(volume,LENGTH(volume)-1)::numeric*1000
           when right(volume,1)='M' then left(volume,LENGTH(volume)-1)::numeric*1000000
           else 0
      end) as new_volume
  from trading.prices
  where date_part('year',market_date)=2020
  group by ticker,month_start
)
select ticker,month_start,
  sum(new_volume) over(partition by ticker order by month_start range between unbounded preceding and current row)
  as cumulative_monthly_volume
from cte
group by ticker,month_start,new_volume;

--Q4 Calculate the daily percentage change in volume for each ticker in the trading.prices table
--Percentage change can be calculated as (current - previous) / previous
--Multiply the percentage by 100 and round the value to 2 decimal places
--Return data for the first 10 days of August 2021
with cte as
(
  select ticker,market_date,
    case when right(volume,1)='K' then left(volume,LENGTH(volume)-1)::numeric*1000
             when right(volume,1)='M' then left(volume,LENGTH(volume)-1)::numeric*1000000
             else 0
        end as volume
  from trading.prices
  where market_date between '2021-08-01' and '2021-08-10'
  group by ticker,market_date,volume
),
ctee as
(
  select ticker,market_date,volume,lag(volume) over(partition by ticker order by market_date)
  as previous_volume
  from cte
  where volume<>0
  group by ticker,market_date,volume
)
select ticker,market_date,volume,previous_volume,round((((volume-previous_volume)/previous_volume)*100),2)
  as daily_change
from ctee
group by ticker,market_date,volume,previous_volume;


5. Using Table Joins:
 
--Q1 Which top 3 mentors have the most Bitcoin quantity? Return the first_name of the mentors and sort the output from highest to lowest total_quantity
select m.first_name,
  sum(case when t.txn_type='SELL' then -t.quantity else t.quantity end) as total_quantity
from trading.members as m
join trading.transactions as t on
  t.member_id=m.member_id
where t.ticker='BTC'
group by m.first_name
order by total_quantity desc
limit 3;

--Q2 Show the market_date values which have less than 5 transactions? Sort the output in reverse chronological order.
select p.market_date,count(t.txn_id) as no_of_txn
from trading.prices as p
 left join trading.transactions as t on
  p.market_date=t.txn_date and p.ticker=t.ticker
group by p.market_date
having count(t.txn_id)<5
order by p.market_date desc;

--Q3 For this question - we will generate a single table output which solves a multi-part problem about the dollar cost average of BTC purchases.
--Part 1: Calculate the Dollar Cost Average
--What is the dollar cost average (btc_dca) for all Bitcoin purchases by region for each calendar year?
--Create a column called year_start and use the start of the calendar year
--The dollar cost average calculation is btc_dca = SUM(quantity x price) / SUM(quantity)
--Part 2: Yearly Dollar Cost Average Ranking
--Use this btc_dca value to generate a dca_ranking column for each year
--The region with the lowest btc_dca each year has a rank of 1
--Part 3: Dollar Cost Average Yearly Percentage Change
--Calculate the yearly percentage change in DCA for each region to 2 decimal places
--This calculation is (current - previous) / previous
--Finally order the output by region and year_start columns.
with part_one as
(
  select date_trunc('year',t.txn_date) as year_start, m.region,
    sum(t.quantity*p.price)/sum(t.quantity) as btc_dca
  from trading.transactions as t
  join trading.members as m on
    m.member_id=t.member_id
  join trading.prices as p on
    p.ticker=t.ticker and p.market_date=t.txn_date
  where t.ticker='BTC' and t.txn_type='BUY'
  group by year_start,m.region  
),
part_two as
(
  select year_start,region,btc_dca,rank() over(partition by year_start order by btc_dca asc) as dca_ranking
  from part_one
  group by year_start,region,btc_dca
),
part_three as
(
  select year_start,region,dca_ranking,btc_dca,lag(btc_dca) over(partition by year_start order by btc_dca asc) 
    as previous_dca
  from part_two
  group by year_start,region,btc_dca,dca_ranking
)
select year_start,region,dca_ranking,btc_dca,previous_dca,round((100*(btc_dca-previous_dca)/previous_dca)::numeric,2)
  as dca_percentage_change
from part_three
group by year_start,region,btc_dca,dca_ranking,previous_dca
order by year_start,region,dca_ranking;