#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"

# Do not change code above this line. Use the PSQL variable above to query your database.

# Query 1 ok
echo -e "\nTotal number of goals in all games from winning teams:"
echo "$($PSQL "SELECT SUM(winner_goals) FROM games")"

# Query 2 ok
echo -e "\nTotal number of goals in all games from both teams combined:"
echo "$($PSQL "SELECT SUM(winner_goals + opponent_goals) FROM games")"

# Query 3 ok
echo -e "\nAverage number of goals in all games from the winning teams:"
echo "$($PSQL "SELECT AVG(winner_goals) FROM games")"

# Query 4 ok
echo -e "\nAverage number of goals in all games from the winning teams rounded to two decimal places:"
echo "$($PSQL "SELECT ROUND(AVG(winner_goals), 2) FROM games")"

# Query 5 ok
echo -e "\nAverage number of goals in all games from both teams:"
echo "$($PSQL "SELECT AVG(winner_goals + opponent_goals) FROM games")"

# Query 6 ok
echo -e "\nMost goals scored in a single game by one team:"
echo "$($PSQL "SELECT MAX(winner_goals) FROM games")"

# Query 7 ok
echo -e "\nNumber of games where the winning team scored more than two goals:"
echo "$($PSQL "SELECT COUNT(*) FROM games WHERE winner_goals > 2")"

# Query 8 ok
echo -e "\nWinner of the 2018 tournament team name:"
echo "$($PSQL "SELECT name FROM teams WHERE team_id=(SELECT winner_id FROM games WHERE round='Final' AND year=2018)")"

# Query 9 (add back opponent's name)
echo -e "\nList of teams who played in the 2014 'Eighth-Final' round:"
#echo "$($PSQL "SELECT t.name FROM games AS g JOIN teams AS t ON g.winner_id = t.team_id WHERE g.round = 'Eighth-Final' AND g.year = 2014 ORDER BY t.name ASC")"
echo "$($PSQL "SELECT w.name
FROM games
JOIN teams AS w ON games.winner_id = w.team_id
WHERE games.year = 2014 AND games.round = 'Eighth-Final'
UNION ALL
SELECT o.name
FROM games
JOIN teams AS o ON games.opponent_id = o.team_id
WHERE games.year = 2014 AND games.round = 'Eighth-Final'
ORDER BY name ASC;")"

# Query 10 ok
echo -e "\nList of unique winning team names in the whole data set:"
echo "$($PSQL "SELECT DISTINCT name FROM teams JOIN games ON teams.team_id = games.winner_id ORDER BY name ASC")"

# Query 11 ok 
echo -e "\nYear and team name of all the champions:"
echo "$($PSQL "SELECT year, name FROM teams JOIN games ON teams.team_id = games.winner_id WHERE round='Final' GROUP BY year, name")"

# Query 12 ok 
echo -e "\nList of teams that start with 'Co':"
echo "$($PSQL "SELECT name FROM teams WHERE name LIKE 'Co%'")"