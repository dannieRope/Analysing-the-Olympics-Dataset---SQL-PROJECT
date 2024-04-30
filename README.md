![Olympic_rings_without_rims svg](https://github.com/dannieRope/Analysing-the-Olympics-Dataset---SQL-PROJECT/assets/132214828/8ff82aea-1760-438f-b023-58b6f27856dc)


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

- Total no of nations participation keep increasing over time and peaked at 2016 with 207 of nations

**5. Which year saw the highest and lowest no of countries participating in olympics?**

```SQL
WITH hl_cte AS(
   SELECT     
	   games,
	   COUNT(DISTINCT(NOC)) AS totalcountries,
	   ROW_NUMBER()OVER(ORDER BY COUNT(DISTINCT(NOC)) DESC) AS highest_rank,
	   ROW_NUMBER()OVER(ORDER BY COUNT(DISTINCT(NOC)) ASC) AS lowest_rank
   FROM dbo.athlete_events
   GROUP BY games
)
SELECT 
		CONCAT(games,'-',totalcountries) AS Year,
		CASE WHEN highest_rank = 1 THEN 'highest' ELSE ' ' END AS Rank_category
FROM hl_cte 
WHERE highest_rank = 1
UNION
SELECT 
		CONCAT(games,'-',totalcountries) AS Year,
		CASE WHEN lowest_rank = 1 THEN 'Lowest' ELSE ' ' END AS Rank_category
FROM hl_cte 
WHERE lowest_rank = 1
```

![Screenshot 2024-04-28 050612](https://github.com/dannieRope/Analysing-the-Olympics-Dataset---SQL-PROJECT/assets/132214828/18b7eff1-4310-4bf4-b929-c3455af36e98)

- Participation was at its lowest in 1896 with only 12 nations. Howerver, 2016 recorded the highest number of nations participation of 207

**6. Which nation has participated in all of the olympic games?**

```sql

WITH region_games_count AS (
    SELECT 
        region,
        COUNT(DISTINCT games) AS no_participation
    FROM dbo.athlete_events E
    JOIN dbo.noc_regions R ON E.NOC = R.NOC
    GROUP BY region
)
SELECT region, no_participation
FROM region_games_count
WHERE no_participation = (
    SELECT MAX(no_participation)
    FROM region_games_count
);
```
![Screenshot 2024-04-28 051258](https://github.com/dannieRope/Analysing-the-Olympics-Dataset---SQL-PROJECT/assets/132214828/ad2c7103-c954-4785-b5ba-b8e17e699564)

- France, Italy, Switzerland and UK have parcipated in all the 51 olympic games


**7. Identify the sport which was played in all summer olympics.**

```sql
WITH summer_cte AS (
                         SELECT 
			      sport,
			      COUNT(DISTINCT games) AS summerOlympics
			 FROM dbo.athlete_events
			 WHERE season = 'Summer'
			 GROUP BY sport
)
SELECT 
      sport,
	  summerOlympics
FROM summer_cte 
WHERE summerOlympics = (SELECT MAX(summerOlympics)
                        FROM summer_cte);
```

![Screenshot 2024-04-28 051544](https://github.com/dannieRope/Analysing-the-Olympics-Dataset---SQL-PROJECT/assets/132214828/c8803cea-95e2-43d2-a6cc-2c266f8b99f3)

- Gymnastics, Swimming,Fencing, Cycling and Athletics were played in all summer olympic games

**8. Which Sports were just played only once in the olympics?**

```sql
WITH sport_cte AS(
              SELECT DISTINCT Games,
			                  Sport
			  FROM dbo.athlete_events
),
     played AS( 
	          SELECT sport,
			         COUNT(1) AS no_played
			  FROM sport_cte
			  GROUP BY sport
)
SELECT S.sport,
       S.Games,
	   P.no_played
FROM sport_cte S
JOIN played P ON S.sport = P.sport
WHERE P.no_played = 1;
```
![Screenshot 2024-04-28 051901](https://github.com/dannieRope/Analysing-the-Olympics-Dataset---SQL-PROJECT/assets/132214828/96d0e43f-319b-49e4-a501-cbda402b71fd)

- Cricket, Croquet, Military Ski Patrol, Motorboating, Jeu De Paume, Aeronautics, Roque, Basque Pelota, Rugby Sevens, and Racquets were played only once in the olympics games

**9. Fetch the total no of sports played in each olympic games.**

```SQL
WITH sports_cte AS (
             SELECT DISTINCT games,sport
			 FROM dbo.athlete_events
)
SELECT games,
       COUNT(sport) AS sportplayed
FROM sports_cte
GROUP BY games
ORDER BY sportplayed DESC;
```

![Screenshot 2024-04-30 063945](https://github.com/dannieRope/Analysing-the-Olympics-Dataset---SQL-PROJECT/assets/132214828/167ce725-7fc1-48af-8ed5-49873ff0c451)

- 2008,2004, and 2000 Olympic games recorded the highest number of sports played 34, whilest 1932 olympic games recorded the lowest (7)


**10. Fetch details of the oldest athletes to win a gold medal.**

```sql
WITH age_cte AS (
       SELECT
             name,
             age,
             sex,
            Team,
             city,
             medal
      FROM dbo.athlete_events
      WHERE medal = 'Gold' AND age <> 'NA'
)
SELECT *
FROM age_cte
WHERE age = (SELECT MAX(age)
             FROM age_cte);
```
![Screenshot 2024-04-30 064626](https://github.com/dannieRope/Analysing-the-Olympics-Dataset---SQL-PROJECT/assets/132214828/c3ad8ade-474f-49ac-89f8-f4f72f427c87)

- At age 64, Charles Jacobus and Oscar Gomer Swahn were the oldest atheletes to win Gold medal at the Olympic games
  

**11. Find the Ratio of male and female athletes participated in all olympic games.**

```sql
WITH sex_cte AS (
    SELECT 
		SUM(CASE WHEN sex = 'M' THEN 1 ELSE 0 END) AS males_count,
		SUM(CASE WHEN sex = 'F' THEN 1 ELSE 0 END) AS female_count
	FROM dbo.athlete_events
)
SELECT 
	CONCAT(1,':', ROUND(CAST(males_count AS float)/female_count ,2)) AS males_to_female_ratio
FROM sex_cte;
```

![Screenshot 2024-04-30 064949](https://github.com/dannieRope/Analysing-the-Olympics-Dataset---SQL-PROJECT/assets/132214828/0a19fa2c-aebd-4718-81d5-7f5f057cb0cc)

- The ratio of male to female participation in the Olympic games is 1:3

**12. Fetch the top 5 athletes who have won the most gold medals.**
```sql
WITH gold_cte AS (
                    SELECT 
                                 Name,
				 Medal
		   FROM dbo.athlete_events
		   WHERE  Medal = 'Gold'
)
SELECT TOP 5
      Name,
	  COUNT(medal) AS gold_medals
FROM gold_cte
GROUP BY Name
ORDER BY gold_medals DESC;
```

![Screenshot 2024-04-30 065322](https://github.com/dannieRope/Analysing-the-Olympics-Dataset---SQL-PROJECT/assets/132214828/2aa07f01-360b-4a7c-b762-6c400de81675)

- Michael Fred Phelps, II is the athelete with the most Gold medals followed by Raymond Clarence "Ray" Ewry.
  

**13. Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).**

```sql
WITH medal_cte AS (
                   SELECT 
				Name,
				medal
		   FROM dbo.athlete_events
		   WHERE medal <> 'NA'
)
SELECT TOP 5
	 Name,
	 COUNT(medal) AS medal_count
FROM medal_cte
GROUP BY Name
ORDER BY medal_count DESC;
```
- Michael Fred Phelps, II has won most medals in the olympics followed by Larysa Semenivna Latynina (Diriy-).

**14. Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won.**

```sql
WITH country_cte AS (
                    SELECT 
				region,
				medal
		   FROM dbo.athlete_events e
		   JOIN noc_regions n ON e.NOC = n.NOC
		   WHERE medal <> 'NA'		   
)
SELECT TOP 5
	region,
	COUNT(medal) AS medals_won
FROM country_cte
GROUP BY region
ORDER BY medals_won DESC;
```

![Screenshot 2024-04-30 070055](https://github.com/dannieRope/Analysing-the-Olympics-Dataset---SQL-PROJECT/assets/132214828/026f9f30-f058-4366-8f89-b1e2c4c3b860)

- USA is the most successful country in the Olympic games with most medals followed by Russia and then Germany and UK.


**15. List down total gold, silver and broze medals won by each country.***

```sql
WITH country_cte AS (
    SELECT 
        region,
        medal,
        COUNT(medal) AS medal_count,
        ROW_NUMBER() OVER(PARTITION BY region ORDER BY COUNT(medal) DESC) AS medalrank
    FROM dbo.athlete_events e
    JOIN noc_regions n ON e.NOC = n.NOC
    WHERE medal <> 'NA'		   
    GROUP BY region, medal
)

SELECT
    region AS country,
    SUM(CASE WHEN medal = 'Gold' THEN medal_count ELSE 0 END) AS gold_medals,
    SUM(CASE WHEN medal = 'Silver' THEN medal_count ELSE 0 END) AS silver_medals,
    SUM(CASE WHEN medal = 'Bronze' THEN medal_count ELSE 0 END) AS bronze_medals
FROM country_cte
GROUP BY region
ORDER BY gold_medals DESC;
```
![Screenshot 2024-04-30 070339](https://github.com/dannieRope/Analysing-the-Olympics-Dataset---SQL-PROJECT/assets/132214828/d9bee6d9-6b36-4c41-b9c5-bb8b3434c96b)


**16. List down total gold, silver and broze medals won by each country corresponding to each olympic games.**

```sql
WITH country_cte AS (
    SELECT 
	    games,
        region,
        medal,
        COUNT(medal) AS medal_count,
        ROW_NUMBER() OVER(PARTITION BY region ORDER BY COUNT(medal) DESC) AS medalrank
    FROM dbo.athlete_events e
    JOIN noc_regions n ON e.NOC = n.NOC
    WHERE medal <> 'NA'		   
    GROUP BY region, medal,games
)
SELECT
    games,
    region AS country,
    SUM(CASE WHEN medal = 'Gold' THEN medal_count ELSE 0 END) AS gold_medals,
    SUM(CASE WHEN medal = 'Silver' THEN medal_count ELSE 0 END) AS silver_medals,
    SUM(CASE WHEN medal = 'Bronze' THEN medal_count ELSE 0 END) AS bronze_medals
FROM country_cte
GROUP BY games,region
ORDER BY gold_medals DESC;
```
![Screenshot 2024-04-30 070653](https://github.com/dannieRope/Analysing-the-Olympics-Dataset---SQL-PROJECT/assets/132214828/cc1ce943-cc75-4201-9502-ce005de86f3e)


**17. Identify which country won the most gold, most silver and most bronze medals in each olympic games.**

```sql
WITH country_cte AS (
    SELECT 
        games,
        region AS country,
        medal,
        COUNT(medal) AS medal_count,
        ROW_NUMBER() OVER(PARTITION BY games, medal ORDER BY COUNT(medal) DESC) AS medalrank
    FROM dbo.athlete_events e
    JOIN noc_regions n ON e.NOC = n.NOC
    WHERE medal <> 'NA'		   
    GROUP BY games, region, medal
)
SELECT
    games,
    MAX(CASE WHEN medal = 'Gold' THEN country ELSE NULL END) AS country_with_most_gold,
    MAX(CASE WHEN medal = 'Silver' THEN country ELSE NULL END) AS country_with_most_silver,
    MAX(CASE WHEN medal = 'Bronze' THEN country ELSE NULL END) AS country_with_most_bronze
FROM country_cte
WHERE medalrank = 1
GROUP BY games;
```

![Screenshot 2024-04-30 070902](https://github.com/dannieRope/Analysing-the-Olympics-Dataset---SQL-PROJECT/assets/132214828/5c003475-10b2-4044-adb1-97912dfa7fca)


**18. Identify which country won the most gold, most silver, most bronze medals and the most medals in each olympic games.**

```sql
WITH country_cte AS (
    SELECT 
        games,
        region AS country,
        medal,
        COUNT(medal) AS medal_count,
        ROW_NUMBER() OVER(PARTITION BY games, medal ORDER BY COUNT(medal) DESC) AS medalrank
    FROM dbo.athlete_events e
    JOIN noc_regions n ON e.NOC = n.NOC
    WHERE medal <> 'NA'		   
    GROUP BY games, region, medal
)
SELECT
    games,
    MAX(CASE WHEN medal = 'Gold' THEN country ELSE NULL END) AS country_with_most_gold,
    MAX(CASE WHEN medal = 'Silver' THEN country ELSE NULL END) AS country_with_most_silver,
    MAX(CASE WHEN medal = 'Bronze' THEN country ELSE NULL END) AS country_with_most_bronze,
	MAX(CASE WHEN (medal = 'Gold' OR medal = 'Silver' OR medal = 'Bronze') THEN country ELSE NULL END) AS country_with_most_medals
FROM country_cte
WHERE medalrank = 1
GROUP BY games;
```

![Screenshot 2024-04-30 071142](https://github.com/dannieRope/Analysing-the-Olympics-Dataset---SQL-PROJECT/assets/132214828/743b9ecd-da6b-4ebb-be1f-0fda742ba640)

**19. Which countries have never won gold medal but have won silver/bronze medals?**
```sql
WITH country_cte AS (
    SELECT 
        region AS country,
        medal,
        COUNT(medal) AS medal_count,
		ROW_NUMBER() OVER(PARTITION BY region,medal ORDER BY COUNT(medal) DESC) AS medalrank
    FROM dbo.athlete_events e
    JOIN noc_regions n ON e.NOC = n.NOC
    WHERE medal <> 'NA'	 AND e.NOC NOT IN (SELECT DISTINCT(NOC) FROM dbo.athlete_events WHERE medal = 'Gold')
    GROUP BY region, medal
)
SELECT
    country,
   SUM(CASE WHEN medal = 'Gold' THEN medal_count ELSE 0 END) AS gold_medals,
    SUM(CASE WHEN medal = 'Silver' THEN medal_count ELSE 0 END) AS silver_medals,
    SUM(CASE WHEN medal = 'Bronze' THEN medal_count ELSE 0 END) AS bronze_medals
FROM country_cte
GROUP BY country
ORDER BY gold_medals,silver_medals DESC,bronze_medals DESC;
```

![Screenshot 2024-04-30 072103](https://github.com/dannieRope/Analysing-the-Olympics-Dataset---SQL-PROJECT/assets/132214828/9cc9fcb4-fcfe-494c-ac99-59f82be82cef)

- Ghana is the country with the highest number of medals(21) amoung countries with no gold medals

**20. In which Sport/event, India has won highest medals.**

```sql
WITH region_cte AS (
    
 SELECT 
     region,
     sport,
	 COUNT(medal) AS medal_count,
	 ROW_NUMBER()OVER(PARTITION BY region,sport ORDER BY COUNT(medal) DESC) AS rnk
 FROM dbo.athlete_events e
 JOIN noc_regions n ON e.NOC = n.NOC
 WHERE medal <> 'NA'	 
 GROUP BY  region,sport
 )  

SELECT region,
       sport,
       medal_count
FROM region_cte
WHERE region = 'India' AND medal_count = (SELECT MAX(medal_count) FROM region_cte region  WHERE region = 'India')
```
![Screenshot 2024-04-30 072615](https://github.com/dannieRope/Analysing-the-Olympics-Dataset---SQL-PROJECT/assets/132214828/1f886648-1f03-4d03-89ce-99fdc64c1abc)

- India won more medals in Hockey than any other sport in the Olympic games.

**21. Break down all olympic games where india won medal for Hockey and how many medals in each olympic games.**

```sql
SELECT 
          games,
	  region,
	  sport,
	  COUNT(medal) AS medal_count
FROM dbo.athlete_events e
JOIN noc_regions n ON e.NOC = n.NOC
WHERE medal <> 'NA'	AND region = 'India' AND sport = 'Hockey'
GROUP BY Games,region,Sport;
```

![Screenshot 2024-04-30 072845](https://github.com/dannieRope/Analysing-the-Olympics-Dataset---SQL-PROJECT/assets/132214828/c411ea04-3c77-4445-abba-20d9d700ccf0)


# CONCLUSION

Working with this dataset has been thoroughly enjoyable. Throughout this journey, I've gained valuable knowledge and I trust you've found it equally enlightening. 
Your feedback is greatly appreciated, so don't hesitate to share your thoughts or inquiries in the comments.  Find the sql Script here

I sincerely appreciate your time and attention.

























