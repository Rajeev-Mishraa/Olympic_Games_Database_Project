/* 120 years of Olympic history database */

use Olympic_database
select * from athlete_events
select * from noc_regions

/*	    Question Set   */

/* Q1: How many olympics games have been held? */

SELECT COUNT(DISTINCT Games) AS total_olympic_games
FROM athlete_events

/* Q2: List down all Olympics games held so far. */

SELECT DISTINCT Year, Season, City FROM athlete_events
ORDER BY Year ASC

/* Q3: Mention the total no of nations who participated in each olympics game? */

SELECT Games, COUNT( DISTINCT NOC) AS total_participant_nation FROM athlete_events
GROUP BY Games
ORDER BY Games ASC


/* Q4: Which year saw the highest and lowest no of countries participating in olympics? */

WITH t1 AS (
    SELECT TOP(1) Year, COUNT(DISTINCT NOC) AS num_of_nations 
	FROM athlete_events
    GROUP BY Year
    ORDER BY num_of_nations DESC),
t2 AS (
   SELECT TOP(1) Year, COUNT(DISTINCT NOC) AS num_of_nations 
   FROM athlete_events
   GROUP BY Year
   ORDER BY num_of_nations ASC)
SELECT t1.Year AS highest_participation_year, t1.num_of_nations AS highest_count,
t2.Year AS lowest_participation_year, t2.num_of_nations AS lowest_count
FROM t1, t2;

/* Q5: Which nation has participated in all of the olympic games? */

SELECT Team AS nation, COUNT( DISTINCT Games) AS total_participation FROM athlete_events
GROUP BY Team
HAVING COUNT( DISTINCT Games) = (SELECT COUNT( DISTINCT Games) FROM athlete_events)

/* Q6: Identify the sport which was played in all summer olympics. */

SELECT Sport, COUNT(distinct Games) AS num_of_games FROM athlete_events
WHERE Season = 'Summer'
GROUP BY Sport
HAVING COUNT(DISTINCT Year) = (SELECT COUNT(DISTINCT Year) FROM athlete_events WHERE Season = 'Summer')

/* Q7: Which Sports were just played only once in the olympics? */

SELECT  Sport, COUNT( distinct Games) AS num_of_games
FROM athlete_events
GROUP BY Sport
HAVING COUNT( distinct Games) = 1

/* Q8: Fetch the total no of sports played in each olympic games. */

SELECT Games, COUNT(DISTINCT Sport) AS total_sports
FROM athlete_events
GROUP BY Games
ORDER BY total_sports DESC

/* Q9:  Fetch the top 5 athletes who have won the most gold medals. */

WITH gold_medal_count AS (
     SELECT Name,
	 SUM(CASE WHEN Medal = 'Gold' THEN 1 ELSE 0 END) AS total_gold_medals
	 FROM athlete_events
	 GROUP BY Name
	 )
SELECT TOP(5) Name, total_gold_medals
FROM gold_medal_count
ORDER BY total_gold_medals DESC 

/* Q10: List down total gold, silver and bronze medals won by each country. */

SELECT noc_regions.region, 
       SUM(CASE WHEN Medal = 'Gold' THEN 1 ELSE 0 END) AS total_gold_medals,
	   SUM(CASE WHEN Medal = 'Silver' THEN 1 ELSE 0 END) AS total_silver_medals,
	   SUM(CASE WHEN Medal = 'Bronze' THEN 1 ELSE 0 END) AS total_bronze_medals
FROM athlete_events 
JOIN noc_regions ON noc_regions.NOC = athlete_events.NOC
GROUP BY noc_regions.region
ORDER BY total_gold_medals DESC
      
      









