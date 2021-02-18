-- What range of years for baseball games played does the provided database cover?
select max(yearid) - min(yearid), min(yearid) as first_year, max(yearid) as last_year
from teams;
