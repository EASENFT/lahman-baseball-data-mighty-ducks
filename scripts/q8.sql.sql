/*q.8 Using the attendance figures from the homegames table, find the teams and parks which had the
top 5 average attendance per game in 2016 (where average attendance is defined as total attendance
divided by number of games). Only consider parks where there were at least 10 games played. 
Report the park name, team name, and average attendance. Repeat for the lowest 5 average
attendance.*/


Select (Sum(hg.attendance)/(count(hg.attendance))) AS avg_attendance, p.park_name, team, count(hg.attendance) as number_of_games
From homegames as hg left join parks as p on hg.park =p.park
Group by p.park, team
HAVING count(hg.attendance) >10
Order by avg_attendance desc
Limit 5;
-- pt 1. top 5 teams parks and teams with highest avg attendance 

SELECT (SUM(hg.attendance)/(COUNT(hg.attendance))) AS avg_attendance, p.park_name, team,
COUNT(hg.attendance) as number_of_games
FROM homegames AS hg 
LEFT JOIN parks AS p ON hg.park =p.park
GROUP BY p.park, team
HAVING COUNT(hg.attendance) >10
ORDER BY avg_attendance 
LIMIT 5;
--pt 2. bottom 5 teams with lowest avg attendance 
