--No. 4
WITH posnames AS (SELECT fielding.playerid as playerid,
				  	CONCAT(namefirst, ' ', namelast) as name,
				  	CASE WHEN fielding.pos = 'P' THEN 'Battery'
						WHEN fielding.pos = 'C' THEN 'Battery'
						WHEN fielding.pos = 'OF' THEN 'Outfield'
						ELSE 'Infield' END as position_type
				FROM fielding INNER JOIN people ON people.playerid = fielding.playerid
				WHERE fielding.yearid = 2016)
SELECT posnames.position_type as positions2016,
	COUNT(posnames.position_type) as n_position_types
FROM posnames
GROUP BY posnames.position_type;

--confirming our numbers match the total number of players in 2016.
SELECT COUNT(playerid)
FROM fielding
WHERE yearid = 2016;
--yes, they do. 938+661+354=1953

--no. 7
SELECT *
FROM teams
LIMIT 10;

--Select non-world series winners, order by descending wins.
SELECT yearid,
	name, 	
	wswin,
	w as wins
FROM teams
WHERE wswin <> 'Y'
AND yearid >= 1970
GROUP BY yearid, wswin, name, w
ORDER BY wins desc;

--2001 Seattle Mariners, but the above only gave me N values. Now looking adding nulls
SELECT yearid,
	name, 	
	wswin,
	w as wins
FROM teams
WHERE wswin IS NULL
OR wswin like 'N'
AND yearid >= 1970
GROUP BY yearid, wswin, name, w
ORDER BY wins desc;
--Still the 2001 Seattle Mariners with 116 wins. 

--Select world series winners, order them by ascending wins.
SELECT yearid,
	name, 	
	wswin,
	w as wins
FROM teams
WHERE wswin = 'Y'
AND yearid >= 1970
GROUP BY yearid, wswin, name, w
ORDER BY wins;
/*Lowest wins for world series winener is 1981 LA Dodgers at 63 wins. Why?
"The 1981 Major League Baseball season had a players' strike, which lasted 
from June 12 to July 31, 1981, and split the season in two halves. The 
All-Star Game was originally to be played on July 14, but was cancelled 
due to the strike. It was then brought back and played on August 9, as a 
prelude to the second half of the season, which began the following day."*/

--Remove 1981 from calc
SELECT yearid,
	name, 	
	wswin,
	w as wins
FROM teams
WHERE wswin = 'Y'
AND yearid >= 1970
AND yearid <> 1981
GROUP BY yearid, wswin, name, w
ORDER BY wins;
--Lowest now is the 2006 St Louis Cardinals with 83 wins. 

--calculating years where most winning team was also world series winning team.
WITH wsw AS (SELECT DISTINCT(yearid) as year,
				name, 	
				wswin,
				w as wins
			FROM teams
			WHERE wswin = 'Y'
			AND yearid >= 1970
			GROUP BY yearid, wswin, name, w),
ranks AS (SELECT RANK () OVER (PARTITION BY yearid ORDER BY w desc) as wrank,
		name,
		w,
	    yearid
	  	FROM teams
	  WHERE yearid >= 1970),
maxers AS (SELECT yearid,
		   name, 
		   wrank, 
		   ranks.w as wins
		   FROM ranks
		   WHERE wrank = 1),
totals as (SELECT DISTINCT(wsw.year),
			maxers.name as max_winner,
			maxers.wins as max_wins,
			wsw.name as wswinner,
			wsw.wins as wswinner_wins
		FROM wsw INNER JOIN maxers ON wsw.year = maxers.yearid)
SELECT totals.year,
	totals.wswinner,
	wswinner_wins
FROM totals
WHERE totals.max_winner = totals.wswinner;

--12 years. 25.5% of 47 years. This is the best I could do for a query.
WITH wsw AS (SELECT DISTINCT(yearid) as year,
				name, 	
				wswin,
				w as wins
			FROM teams
			WHERE wswin = 'Y'
			AND yearid >= 1970
			GROUP BY yearid, wswin, name, w),
ranks AS (SELECT RANK () OVER (PARTITION BY yearid ORDER BY w desc) as wrank,
		name,
		w,
	    yearid
	  	FROM teams
	  WHERE yearid >= 1970),
maxers AS (SELECT yearid,
		   name, 
		   wrank, 
		   ranks.w as wins
		   FROM ranks
		   WHERE wrank = 1),
totals as (SELECT DISTINCT(wsw.year),
			maxers.name as max_winner,
			maxers.wins as max_wins,
			wsw.name as wswinner,
			wsw.wins as wswinner_wins
		FROM wsw INNER JOIN maxers ON wsw.year = maxers.yearid),
bigtime AS (SELECT totals.year,
				totals.wswinner,
				wswinner_wins
			FROM totals
			WHERE totals.max_winner = totals.wswinner)
SELECT COUNT(bigtime.year) as years_match,
	COUNT(wsw.year) as total_years
FROM bigtime FULL JOIN wsw ON wsw.year = bigtime.year;
