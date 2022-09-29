#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL"TRUNCATE TABLE games, teams")

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
#inserting the teams to the teams table
do
#inserting the winners
  TEAMS=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
  if [[ $WINNER != "winner" ]]
  then 
    if [[ -z $TEAMS ]]
    then 
      INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ INSERT_TEAM == "INSERT 0 1" ]]
      then
        echo Inserted TO teams, $WINNER
      fi
    fi
  fi
#inserting the opponents
    TEAMS2=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
  if [[ $OPPONENT != "opponent" ]]
  then 
    if [[ -z $TEAMS2 ]]
    then 
      INSERT_TEAM2=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ INSERT_TEAM2 == "INSERT 0 1" ]]
      then
        echo Inserted TO teams, $OPPONENT
      fi
    fi
  fi
#inserting all the games and games data columns
  TEAM_ID_WINNER=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
  TEAM_ID_OPPONENT=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")

  if [[ -n $TEAM_ID_WINNER || -n $TEAM_ID_OPPONENT ]]
  then
    if [[ $YEAR != "year" ]]
    then 
      INSERT_GAMES=$($PSQL"INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $TEAM_ID_WINNER, $TEAM_ID_OPPONENT, $WINNER_GOALS, $OPPONENT_GOALS)")
      if [[ $INSERT_GAMES == "INSERT 0 1" ]]
      then
        echo Inserted to games, $YEAR
      fi
    fi
  fi
done