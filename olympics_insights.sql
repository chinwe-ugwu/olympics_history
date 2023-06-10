SELECT * 
FROM dbo.athlete_events;

/*
---------------------------------------------------------------------------------------------------------------------------------------
* I will be querying the above table to answer some questions regarding the olympics as well as pulling some interesting insights
* from the data.
*
* Each question will be viewed as a sort of problem statement to be solved using SQL queries.
* A more concise visualization will come after, with either Tableau or Power BI software.
----------------------------------------------------------------------------------------------------------------------------------------
*/

/*
* 1. How many Olympic games have been held?
-------------------------------------------------------------------------------------
*/
SELECT COUNT(DISTINCT(Games))
FROM dbo.athlete_events;
/* Result = 51, meaning the olympic games have been held 51 times since it's inception*/
/*
-------------------------------------------------------------------------------------
* 2. List down all Olympics games held so far
-------------------------------------------------------------------------------------
*/

SELECT DISTINCT(Games) AS all_games
FROM dbo.athlete_events
ORDER BY Games ASC;

/*
****************
	RESULT
****************
	Games	
1896 Summer
1900 Summer
1904 Summer
1906 Summer
1908 Summer
1912 Summer
1920 Summer
1924 Summer
1924 Winter
1928 Summer
1928 Winter
1932 Summer
1932 Winter
1936 Summer
1936 Winter
1948 Summer
1948 Winter
1952 Summer
1952 Winter
1956 Summer
1956 Winter
1960 Summer
1960 Winter
1964 Summer
1964 Winter
1968 Summer
1968 Winter
1972 Summer
1972 Winter
1976 Summer
1976 Winter
1980 Summer
1980 Winter
1984 Summer
1984 Winter
1988 Summer
1988 Winter
1992 Summer
1992 Winter
1994 Winter
1996 Summer
1998 Winter
2000 Summer
2002 Winter
2004 Summer
2006 Winter
2008 Summer
2010 Winter
2012 Summer
2014 Winter
2016 Summer
**************
-------------------------------------------------------------------------------------
3. Mention the total no of nations who participated in each olympics game?
-------------------------------------------------------------------------------------
*/

SELECT 
	Games, 
	COUNT(DISTINCT(NOC)) AS total_countries
FROM dbo.athlete_events
GROUP BY Games
ORDER BY Games;

/*
*********************************
			RESULT
*********************************
Games			Total countries
1896 Summer		12
1900 Summer		31
1904 Summer		15
1906 Summer		21
1908 Summer		22
1912 Summer		29
1920 Summer		29
1924 Summer		45
1924 Winter		19
1928 Summer		46
1928 Winter		25
1932 Summer		47
1932 Winter		17
1936 Summer		49
1936 Winter		28
1948 Summer		59
1948 Winter		28
1952 Summer		69
1952 Winter		30
1956 Summer		72
1956 Winter		32
1960 Summer		84
1960 Winter		30
1964 Summer		93
1964 Winter		36
1968 Summer		112
1968 Winter		37
1972 Summer		121
1972 Winter		35
1976 Summer		92
1976 Winter		37
1980 Summer		80
1980 Winter		37
1984 Summer		140
1984 Winter		49
1988 Summer		159
1988 Winter		57
1992 Summer		169
1992 Winter		64
1994 Winter		67
1996 Summer		197
1998 Winter		72
2000 Summer		200
2002 Winter		77
2004 Summer		201
2006 Winter		79
2008 Summer		204
2010 Winter		82
2012 Summer		205
2014 Winter		89
2016 Summer		207
**********************
*/

/*
-------------------------------------------------------------------------------------
4. Which year saw the highest and lowest no of countries participating in olympics?
-------------------------------------------------------------------------------------
*/
 
 WITH all_games AS (
	SELECT Games, 
	COUNT(DISTINCT(NOC)) AS total_countries
	FROM dbo.athlete_events
	GROUP BY Games
	)
	SELECT MAX(total_countries) Max, MIN(total_countries) Min
	FROM all_games;

/*We get that the highest(Max) number of country attendance is 207 and the lowest(Min) is 12. We can use this info to locate the particular years these attendances were registered*/

WITH all_games AS (
	SELECT 
	Games, 
	COUNT(DISTINCT(NOC)) AS total_countries
	FROM dbo.athlete_events
	GROUP BY Games
	)
	SELECT * 
	FROM all_games
	WHERE total_countries = 12 OR total_countries = 207;
/*
**********************************************************************************************
The lowest number of countries was recorded in 1896 Summer with 12 countries in attendance.
The highest number of countries was recorded in 2016 Summer with 207 countries in attendance.
**********************************************************************************************


---------------------------------------------------------------------------------------------
5. Which nation has participated in all of the Olympic games? 
---------------------------------------------------------------------------------------------
*/
WITH t1 AS (
	SELECT DISTINCT NOC, Games
	FROM dbo.athlete_events
	),
	t2 AS (
	SELECT NOC, COUNT(Games) count_games
	FROM t1
	GROUP BY NOC
	)
	SELECT * 
	FROM t2
	ORDER BY count_games DESC;
/*
*****************
	RESULTS
*****************
	SUI	51
	ITA	51
	FRA	51
	GBR	51
*****************
---------------------------------------------------------------------------------------------
6. Identify the sport which was played in all summer olympics. 
---------------------------------------------------------------------------------------------
*/
WITH 
	t1 AS (
	SELECT DISTINCT Games
	FROM dbo.athlete_events
	WHERE Season = 'Summer'
	),
	t2 AS (
	SELECT DISTINCT Sport, Games
	FROM dbo.athlete_events
	WHERE Season = 'Summer'
	),
	t3 AS (
	SELECT Sport, COUNT(Games) no_of_games
	FROM t2
	GROUP BY Sport
	)
	SELECT * 
	FROM t3
	WHERE no_of_games = 29;

/*
***********************
		Result
***********************
	Gymnastics	29
	Fencing		29
	Swimming	29
	Cycling		29
	Athletics	29
***********************
---------------------------------------------------------------------------------------------
7. Which Sports were played only once in the olympics? 
---------------------------------------------------------------------------------------------
*/
WITH 
	t1 AS (
	SELECT DISTINCT Games
	FROM dbo.athlete_events
	),
	t2 AS (
	SELECT DISTINCT Sport, Games
	FROM dbo.athlete_events
	),
	t3 AS (
	SELECT Sport, COUNT(Games) no_of_games
	FROM t2
	GROUP BY Sport
	)
	SELECT * 
	FROM t3
	WHERE no_of_games = 1
	ORDER BY Sport;

/*
*************************************************
					RESULT					   	|
*************************************************
Aeronautics			1							|
Basque Pelota		1							|
Cricket				1							|
Croquet				1							|
Jeu De Paume		1							|
Military Ski Patrol	1							|
Motorboating		1							|
Racquets			1							|
Roque				1							|
Rugby Sevens		1							|
*************************************************

---------------------------------------------------------------------------------------------
8. Fetch the total no of sports played in each olympic games. 
---------------------------------------------------------------------------------------------
*/
SELECT *
FROM dbo.athlete_events;

WITH t2 AS (
	SELECT DISTINCT Games, Sport
	FROM athlete_events
	),
	t3 AS (
	SELECT Games, COUNT(Sport) count_of_sport
	FROM t2
	GROUP BY Games
	)
	SELECT *
	FROM t3
	ORDER BY count_of_sport DESC;
	
/*
*******************************************************************************
				RESULT  
Only first 10 rows are shown, you can run query to view the full list
*******************************************************************************
2016 Summer	34
2008 Summer	34
2004 Summer	34
2000 Summer	34
2012 Summer	32
1996 Summer	31
1992 Summer	29
1988 Summer	27
1984 Summer	25
1920 Summer	25
*********************
------------------------------------------------------------------
9. Fetch details of the oldest athletes to win a gold medal.
------------------------------------------------------------------
*/

SELECT Name, Age, Sport, Medal
FROM dbo.athlete_events
WHERE Age NOT LIKE 'N%' AND Medal = 'Gold'
ORDER BY Age DESC;

/*
*******************************************
					RESULT
*******************************************
There are 2 athletes of the oldest age 
with Gold medals in the Olympics
Name	          Age	Sport	   Medal
Charles Jacobus	  64	Roque	    Gold
Oscar Gomer Swahn 64	Shooting	Gold
*******************************************

---------------------------------------------------------------------------------------------
10. Find the Ratio of male and female athletes participating in all Olympic games.
---------------------------------------------------------------------------------------------
*/
WITH t1 AS (
	SELECT CAST(COUNT(DISTINCT Name) AS FLOAT) males
	FROM dbo.athlete_events
	WHERE Sex = 'M'
	),
	t2 AS (
	SELECT CAST(COUNT(DISTINCT Name) AS FLOAT) females
	FROM dbo.athlete_events
	WHERE Sex = 'F'
	) 
	SELECT CONCAT('1:', ROUND((males/females), 2)) ratio
	FROM t1, t2;
/*
*************************************************
					RESULT
*************************************************
The ratio of female to male athletes throughout 
the history of the Olympics is approximately 1:3
*************************************************

---------------------------------------------------------------------------------------------
11. Fetch the top 5 athletes who have won the most gold medals.
---------------------------------------------------------------------------------------------
*/
	SELECT Name, Team, COUNT(Medal) No_of_medals
	FROM dbo.athlete_events
	WHERE Medal NOT LIKE 'N%' AND Medal = 'Gold'
	GROUP BY Name, Team
	ORDER BY No_of_medals DESC
	OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY
/*
**************************************************
					RESULT
**************************************************
The top 5 athletes with the most gold medals are as follows:
Name							    Team	      No_of_medals
Michael Fred Phelps, II	            United States	23
Raymond Clarence "Ray" Ewry	        United States	10
Paavo Johannes Nurmi	            Finland	        9
Larysa Semenivna Latynina (Diriy-)	Soviet Union	9
Frederick Carlton "Carl" Lewis	    United States	9

---------------------------------------------------------------------------------------------
12. Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).
---------------------------------------------------------------------------------------------
*/
	SELECT Name, Team, COUNT(Medal) No_of_medals
	FROM dbo.athlete_events
	WHERE Medal NOT LIKE 'N%'
	GROUP BY Name, Team
	ORDER BY No_of_medals DESC
	OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY
/*
********************************
		RESULT
********************************
The top 5 athletes who have won the most medals are as follows:
Name	                            Team	        No_of_medals
Michael Fred Phelps, II	            United States	28
Larysa Semenivna Latynina (Diriy-)	Soviet Union	18
Nikolay Yefimovich Andrianov	    Soviet Union	15
Edoardo Mangiarotti	                Italy	        13
Takashi Ono	                        Japan	        13

---------------------------------------------------------------------------------------------
13. Fetch the top 5 most successful countries in olympics. Success is defined by the number of medals won.
---------------------------------------------------------------------------------------------
*/
	SELECT NOC, COUNT(Medal) no_of_medals
	FROM dbo.athlete_events
	WHERE Medal NOT LIKE 'N%'
	GROUP BY NOC
	ORDER BY no_of_medals DESC
	OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;
/*
*******************************************
				RESULTS
*******************************************
NOC	no_of_medals
USA	5637
URS	2503
GER	2165
GBR	2068
FRA	1777
---------------------------------------------------------------------------------------------
14. List down total no. of gold, silver and bronze medals won by each country
---------------------------------------------------------------------------------------------
*/
	SELECT NOC, Medal, COUNT(Medal) No_of_Medals
	FROM dbo.athlete_events
	WHERE Medal NOT LIKE 'N%'
	GROUP BY NOC, Medal
	ORDER BY No_of_Medals DESC
	OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;
/*
******************************
		RESULTS
******************************
NOC	Medal	No_of_Medals
USA	Gold	2638
USA	Silver	1641
USA	Bronze	1358
URS	Gold	1082
GER	Bronze	746
GER	Gold	745
GBR	Silver	739
URS	Silver	732
URS	Bronze	689
GBR	Gold	678
******************************
---------------------------------------------------------------------------------------------
15. List down total gold, silver and bronze medals won by each country corresponding to each olympic games.
---------------------------------------------------------------------------------------------
*/
	SELECT NOC, Games, Medal, COUNT(Medal) No_of_Medals
	FROM dbo.athlete_events
	WHERE Medal NOT LIKE 'N%'
	GROUP BY Games, 
			 NOC,
			 Medal
/*
******************************************
					RESULT					 
******************************************
NOC	Games			Medal	No_of_Medals
AUS	1896 Summer		Bronze		1
AUS	1896 Summer		Gold		2
AUT	1896 Summer		Bronze		2
AUT	1896 Summer		Gold		2
AUT	1896 Summer		Silver		1
DEN	1896 Summer		Bronze		3
DEN	1896 Summer		Gold		1
DEN	1896 Summer		Silver		2
FRA	1896 Summer		Bronze		2
FRA	1896 Summer		Gold		5
**********************************************
