# 💸 Cryptocurrency Case Study

#### Introduction

In our fictitious case study - Danny's data mentors from the Data With Danny team have been busy trading cryptocurrency markets since 2017.

Our main purpose for this case study is to analyze the performance of the DWD mentors over time. We will accomplish this by writing SQL queries to utilize all available datasets to answer a series of realistic business questions

***

#### Our Available Datasets

All of our data for this case study exists within the trading schema in our PostgreSQL database.

There are 3 data tables available to us in this schema which we can use to run our SQL queries with:

1. members

2. prices

3. transactions

***

#### Data Dictionary

Before we dive further into our cryptocurrency case study - let's first explore the data dictionary for the 3 datasets available to use in our PostgreSQL database.

1. trading.members

The trading.members table consists of information about the mentors from the Data With Danny team.

|Column Name|	Description|
|-----------|-------------|
|member_id|	unique id for each mentor|
|first_name|	first name for each mentor|
|region	region| where each mentor is from|

2. trading.prices

The trading.prices table consists of daily price and volume information from January 2017 through to August 2021 for the 2 most popular cryptocurrency tickers: Bitcoin and Ethereum

|Column Name|	Description|
|-----------|------------|
|ticker|	one of either BTC or ETH|
|market_date|	the date for each record|
|price|	closing price at end of day|
|open|	the opening price|
|high|	the highest price for that day|
|low|	the lowest price for that day|
|volume|	the total volume traded|
|change	%| change in daily price|

3. trading.transactions

The trading.transactions table consists of buy and sell transactions data for each trade made by the DWD mentors.

|Column Name|	Description|
|-----------|------------|
|txn_id|	unique ID for each transaction|
|member_id|	member identifier for each trade|
|ticker|	the ticker for each trade|
|txn_date|	the date for each transaction|
|txn_type|	either BUY or SELL|
|quantity|	the total quantity for each trade|
|percentage_fee|	% of total amount charged as fees|
|txn_time|	the timestamp for each trade|

***

#### Entity Relationship Diagram

![image](https://github.com/IshaBhardwaj15/Live-SQL-Workshop-O-reilly/blob/main/ss/crypto-erd.png)

***
