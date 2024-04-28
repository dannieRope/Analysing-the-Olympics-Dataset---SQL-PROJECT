# INTRODUCTION

As someone who loves both data and the Olympic Games, I've been diving into Olympic Games dataset while eagerly waiting for the 2024 Games. This dataset holds a ton of information about past Olympic events from 1896 to 2016. 

I've been exploring it to find interesting facts and patterns. This document will show you what I've discovered and how I did it. We'll look at everything from ancient Olympic history to modern-day trends. 

Let's uncover the stories hidden in the data and learn more about the amazing world of the Olympics.

## **Brief history of Olympic Games.** 

The famous Olympic games started in 776 BC in Olympia and ended in 393 AD lasting over over a millennium. Inspired by the ancient Olympics, a French educator, Baron Pierre de Coubertin proposed the modern day olympic games in 1894.

The Olympic Games were held in Athens in 1896. There were 43 events in which athletes from 14 countries participated, including athletics, cycling, fencing, gymnastics, swimming, and weightlifting.

Since the 1896, the Olympic Games has evolved significantly, with the addition of new sports,the introduction of the Paralympic Games for disabled athletes, and the inclusion of women's competitions.

The Olympic Games continue to unite people from all backgrounds and cultures in the spirit of fair competition and excellence, serving as a symbol of unity, athleticism, and
mutual respect.

## **Objectives** 

We will be  uncover hidden insights by answering the following questions. 

1. Which year was the first olympics games held?

2. How many olympics games have been held?

3. List down all Olympics games held so far.

4. Mention the total no of nations who participated in each olympics game?

5. Which year saw the highest and lowest no of countries participating in olympics?

6. Which nation has participated in all of the olympic games?

7. Identify the sport which was played in all summer olympics.

8. Which Sports were just played only once in the olympics?

9. Fetch the total no of sports played in each olympic games.

10. Fetch details of the oldest athletes to win a gold medal.

11. Find the Ratio of male and female athletes participated in all olympic games.

12. Fetch the top 5 athletes who have won the most gold medals.

13. Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).

14. Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won.

15. List down total gold, silver and broze medals won by each country.

16. List down total gold, silver and broze medals won by each country corresponding to each olympic games.

17. Identify which country won the most gold, most silver and most bronze medals in each olympic games.

18. Identify which country won the most gold, most silver, most bronze medals and the most medals in each olympic games.

19. Which countries have never won gold medal but have won silver/bronze medals? 

20. In which Sport/event, India has won highest medals.

21. Break down all olympic games where india won medal for Hockey and how many medals in each olympic games.

# THE DATASET

The dataset was [downloaded](https://www.kaggle.com/heesoo37/120-years-of-olympic-history-athletes-and-results/download) from Kaggle. Once you download, you will see two csv files: “athlete_events.csv“ and “noc_regions.csv.

The "athlete_events" dataset consists of 15 columns and 271,116 rows. This dataset holds information about the Olympic Games such as player name, height, weight, and age of players, teams, season, etc.

Below is an image of how the data looks like. 

![Screenshot 2024-04-26 120811](https://github.com/dannieRope/Analysing-the-Olympics-Dataset---SQL-PROJECT/assets/132214828/613d690e-ef14-4ecd-9437-0c9cc32c6c4e)

The "noc_regions.csv" dataset consists of 3 columns and 230 rows. It contains names of countries and their abbreviations. Find an image of the dataset below. 

![Screenshot 2024-04-26 150046](https://github.com/dannieRope/Analysing-the-Olympics-Dataset---SQL-PROJECT/assets/132214828/9d2828c2-9fb6-4009-b7f8-71ed356c6c9f)

## Tool 
We will utilize Microsoft SQL Server Management Studio as our primary data tool for this project.

# EDA( EXPLORATORY DATA ANALYSIS)

## Creating a database and importing data

First, we need to establish a fresh database named 'Olympic' to house both the data and pertinent details associated with this project. Following this setup, we will utilize Server Management Studio's Import and Export Wizard to import the two CSV files.

To create a new database, proceed by clicking on the 'New Query' feature within the toolbar area of MS SQL Server Studio. This action will open a new query window. Within this window, execute the following commands:

```sql
DROP DATABASE IF EXISTS Olympic;
CREATE DATABASE Olympic
GO
```

These commands will first check if a database named Olympic already exists and drop it if it does. Then, it will create a fresh database named Olympic.

In the Object Explorer, click on the refresh button and check the databases to find the newly created Olympic database.

![Screenshot 2024-04-26 152716](https://github.com/dannieRope/Analysing-the-Olympics-Dataset---SQL-PROJECT/assets/132214828/45d48f07-eb02-486b-8309-7fdcc7cc3c33)

To import data into the Olympic Database, right-click on the database within SSMS, select 'Tasks' from the menu, then ‘Import Flat File’, and carefully follow the steps outlined by the wizard to configure the data import settings.

![Screenshot (12)](https://github.com/dannieRope/Analysing-the-Olympics-Dataset---SQL-PROJECT/assets/132214828/2c659166-c4e0-488d-9f31-7e5a53417e1d)

Do same for both datasets to get them in mssql studio. 

## Checking values in column for accuracy and consistency

The next step is confirming the integrity of the imported data. Now that it has been imported into the database. It is necessary to verify if there are the same number of columns and rows as before the import. Also, inspect whether the columns have the right data types.

### Observe the data by retrieving first 10 records of the datasets

```sql
SELECT top 10 *
FROM dbo.athlete_events
GO

```

![Screenshot 2024-04-27 080008](https://github.com/dannieRope/Analysing-the-Olympics-Dataset---SQL-PROJECT/assets/132214828/f1e542e8-c618-49da-834f-4ee346c5c163)


```sql
SELECT top 10 *
FROM dbo.noc_regions
GO

```

![Screenshot 2024-04-27 080104](https://github.com/dannieRope/Analysing-the-Olympics-Dataset---SQL-PROJECT/assets/132214828/294a4feb-97a6-4ee1-a61c-7b06f1a21e49)


### Check Column names and Datatypes of the tables

```sql
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'athlete_events';

```
![Screenshot 2024-04-27 080710](https://github.com/dannieRope/Analysing-the-Olympics-Dataset---SQL-PROJECT/assets/132214828/c623b58d-1462-45eb-9fec-790d9e109655)


```sql
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'noc_regions';

```
![Screenshot 2024-04-27 080801](https://github.com/dannieRope/Analysing-the-Olympics-Dataset---SQL-PROJECT/assets/132214828/e6b81bec-63b5-49e6-a394-b4a9047e3151)

Both table have the right columns and data types from the observation. 


### Check the number or rows imported for both tables

```SQL
SELECT COUNT(*) AS rows_imported
FROM athlete_events;

SELECT COUNT(*) AS rows_imported
FROM noc_regions;

```

![Screenshot 2024-04-27 081417](https://github.com/dannieRope/Analysing-the-Olympics-Dataset---SQL-PROJECT/assets/132214828/1155cb04-c0db-43a4-a3b3-957a2bda65b1)

The athlete_events and noc_regions table 271116 and 230 rows respectively which is equal to the number of rows before import of the two tables. 


## Analysis

**1. Which year was the first olympic games held?**

```sql
SELECT DISTINCT TOP 1 
    year
FROM dbo.athlete_events
ORDER BY year ASC;
```
![Screenshot 2024-04-27 201213](https://github.com/dannieRope/Analysing-the-Olympics-Dataset---SQL-PROJECT/assets/132214828/af721714-ec2f-4c4c-af09-b8b455fe3471)

- The modern day Olympics games were first held in 1896

**2. How many olympics games were been held?**

```sql
SELECT 
		COUNT(DISTINCT Games) AS olympic_games
FROM dbo.athlete_events;
```
![Screenshot 2024-04-27 201639](https://github.com/dannieRope/Analysing-the-Olympics-Dataset---SQL-PROJECT/assets/132214828/b8dff6db-96c4-4340-87d4-6c25b141636e)

- 51 Olympics games were held so far


**3. List down all Olympics games held so far.**

```sql
SELECT 
		DISTINCT year AS OlympicYear,
		         season,
				 city
FROM dbo.athlete_events
ORDER BY OlympicYear asc;
```
![Screenshot 2024-04-27 202139](https://github.com/dannieRope/Analysing-the-Olympics-Dataset---SQL-PROJECT/assets/132214828/f279f331-1ce9-493b-b1ee-e6ba479a2001)


**4. Mention the total no of nations who participated in each olympics game?(Trend of participation over time)**

```sql
SELECT 
		Games AS Olympic_game,
		COUNT(DISTINCT NOC) AS TotalNations
FROM dbo.athlete_events
GROUP BY Games
ORDER BY Olympic_game ASC;
```
![Screenshot 2024-04-27 202304](https://github.com/dannieRope/Analysing-the-Olympics-Dataset---SQL-PROJECT/assets/132214828/21c3d85f-be18-4799-a40b-96244a0acb62)


- 1896 Olympics games has the lowest country participation(12), this has increase gradually over the years. 2016 Olympic games has the highest country participation at 207. 









