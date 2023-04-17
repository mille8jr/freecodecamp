#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "truncate teams, games;")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != "winner" ]]
  then

    # get winner_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")

    # if not found
    if [[ -z $WINNER_ID ]]
    then
      # insert team name
      INSERT_TEAM_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_TEAM_NAME == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $WINNER
      fi
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
    fi

      # get opponent_id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
        
    # if not found
    if [[ -z $OPPONENT_ID ]]
    then
      # insert team name
      INSERT_TEAM_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_TEAM_NAME == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $OPPONENT
      fi
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
    fi

    #Add game data with winner_id and opponent_id
    INSERT_GAME=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS);")
    if [[ $INSERT_GAME == "INSERT 0 1" ]]
    then
      echo Inserted game record for $WINNER vs. $OPPONENT
    fi  
  fi
done