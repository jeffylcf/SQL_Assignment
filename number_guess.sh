#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo -e "\n~~~~~ Number Guessing Game ~~~~~\n"

# Prompt for username
echo "Enter your username:"
read USERNAME

# Get user ID
USER_ID=$($PSQL "SELECT u_id FROM users WHERE name = '$USERNAME'")

if [[ -z $USER_ID ]]; then
  # New user
  echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
  INSERT_USER_RESULT=$($PSQL "INSERT INTO users(name) VALUES('$USERNAME')")
  USER_ID=$($PSQL "SELECT u_id FROM users WHERE name = '$USERNAME'")
else
  # Returning user
  GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games WHERE u_id = $USER_ID")
  BEST_GAME=$($PSQL "SELECT MIN(guesses) FROM games WHERE u_id = $USER_ID")
  echo -e "\nWelcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

# Generate secret number
SECRET_NUMBER=$(( RANDOM % 1000 + 1 ))
NUMBER_OF_GUESSES=0

echo -e "\nGuess the secret number between 1 and 1000:"

while true; do
  read GUESS

  if [[ ! $GUESS =~ ^[0-9]+$ ]]; then
    echo -e "\nThat is not an integer, guess again:"
    continue
  fi

  NUMBER_OF_GUESSES=$((NUMBER_OF_GUESSES + 1))

  if [[ $GUESS -lt $SECRET_NUMBER ]]; then
    echo -e "\nIt's higher than that, guess again:"
  elif [[ $GUESS -gt $SECRET_NUMBER ]]; then
    echo -e "\nIt's lower than that, guess again:"
  else
    echo -e "\nYou guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"
    break
  fi
done

# Record the game in the database
INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(u_id, guesses) VALUES($USER_ID, $NUMBER_OF_GUESSES)")
# Number Guessing Game Script
# Implementing user greeting and secret number generation
# Implementing guessing logic and input validation
# Record game results in the database
# Ensure proper handling of user input and database interactions
