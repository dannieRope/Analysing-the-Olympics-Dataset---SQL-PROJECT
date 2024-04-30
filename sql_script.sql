DROP DATABASE IF EXISTS Olympic;
CREATE DATABASE Olympic
GO

USE Olympic
GO

--Retrieve the first 10 records of both tables
SELECT top 10 *
FROM dbo.athlete_events
GO

SELECT top 10 *
FROM dbo.noc_regions
GO

--Check the column names and datatype for both tables
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'athlete_events';


SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'athlete_events';

--Check the number of rows imported for both tables
SELECT COUNT(*) AS rows_imported
FROM athlete_events;

SELECT COUNT(*) AS rows_imported
FROM noc_regions;


-- 1. Which year was the first olympics games held?
SELECT DISTINCT TOP 1 
    year
FROM dbo.athlete_events
ORDER BY year ASC;

-- 2. How many olympics games have been held?
SELECT 
		COUNT(DISTINCT Games) AS olympic_games
FROM dbo.athlete_events;

-- 3. List down all Olympics games held so far.
SELECT 
		DISTINCT year AS OlympicYear,
		         season,
				 city
FROM dbo.athlete_events
ORDER BY OlympicYear asc;

--4. Mention the total no of nations who participated in each olympics game?(Trend of participation over time)
SELECT 
		Games AS Olympic_game,
		COUNT(DISTINCT NOC) AS TotalNations
FROM dbo.athlete_events
GROUP BY Games
ORDER BY Olympic_game ASC;

--5. Which year saw the highest and lowest no of countries participating in olympics?
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

--6. Which nation has participated in all of the olympic games?
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

--7. Identify the sport which was played in all summer olympics.
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

--8. Which Sports were just played only once in the olympics? 
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

--9. Fetch the total no of sports played in each olympic games.
WITH sports_cte AS (
             SELECT DISTINCT games,sport
			 FROM dbo.athlete_events
)
SELECT games,
       COUNT(sport) AS sportplayed
FROM sports_cte
GROUP BY games
ORDER BY sportplayed DESC;

--10. Fetch details of the oldest athletes to win a gold medal.
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

--11. Find the Ratio of male and female athletes participated in all olympic games.
WITH sex_cte AS (
    SELECT 
		SUM(CASE WHEN sex = 'M' THEN 1 ELSE 0 END) AS males_count,
		SUM(CASE WHEN sex = 'F' THEN 1 ELSE 0 END) AS female_count
	FROM dbo.athlete_events
)
SELECT 
	CONCAT(1,':', ROUND(CAST(males_count AS float)/female_count ,2)) AS males_to_female_ratio
FROM sex_cte;

--12. Fetch the top 5 athletes who have won the most gold medals.
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

--13. Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).
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

--14. Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won.
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

--15. List down total gold, silver and broze medals won by each country.
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

--16. List down total gold, silver and broze medals won by each country corresponding to each olympic games.
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

--17. Identify which country won the most gold, most silver and most bronze medals in each olympic games.
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

--18. Identify which country won the most gold, most silver, most bronze medals and the most medals in each olympic games.
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

--19. Which countries have never won gold medal but have won silver/bronze medals?
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



--20. In which Sport/event, India has won highest medals.
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

--21. Break down all olympic games where india won medal for Hockey and how many medals in each olympic games.
SELECT 
      games,
	  region,
	  sport,
	  COUNT(medal) AS medal_count
FROM dbo.athlete_events e
JOIN noc_regions n ON e.NOC = n.NOC
WHERE medal <> 'NA'	AND region = 'India' AND sport = 'Hockey'
GROUP BY Games,region,Sport;

