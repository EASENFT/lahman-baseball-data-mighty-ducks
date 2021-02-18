-- Find the average number of strikeouts per game by decade since 1920. 
-- Round the numbers you report to 2 decimal places. 
-- Do the same for home runs per game. Do you see any trends?

select 
	'strikeouts' as batting,
	round(CAST(float8 (sum(so)::float / sum(g)::float) as numeric), 2) as average, left(game_decade::text, 4) || '''s' as decade
from (
		select g, so, date_trunc('decade', to_date(yearid || '0101', 'YYYYMMDD')) as game_decade
		from batting
		where yearid >= 1920 and so <> 0) as decades_of_games
group by game_decade
union all
select 
	'homeruns' as batting,
	round(CAST(float8 (sum(hr)::float / sum(g)::float) as numeric), 2) as average, left(game_decade::text, 4) || '''s' as decade
from (
		select g, hr, date_trunc('decade', to_date(yearid || '0101', 'YYYYMMDD')) as game_decade
		from batting
		where yearid >= 1920 and hr <> 0) as decades_of_games
group by game_decade
order by decade;

