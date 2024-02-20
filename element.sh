#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
NUM_CHECK="^[0-9]+"

if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
else
  #check if number
  if ! [[ $1 =~ $NUM_CHECK ]]
  then
    #if not, check if name or symbol
    ATOMNAME=$($PSQL"SELECT name FROM elements WHERE name='$1' OR symbol='$1'")
    if [[ -z $ATOMNAME ]]
    then
      #if none return prompt
      echo I could not find that element in the database.
    else
      #set values for atomic number, symbol, type, mass, melting point and boiling point
      ATOMNUM=$($PSQL "SELECT atomic_number FROM elements WHERE name='$ATOMNAME'")
      ELSYMB=$($PSQL "SELECT symbol FROM elements WHERE name='$ATOMNAME'")
      ELTYPE=$($PSQL "SELECT type FROM properties INNER JOIN types USING(type_id) WHERE atomic_number=$ATOMNUM")
      ELMASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMNUM")
      ELMELT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMNUM")
      ELBOIL=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMNUM")
      #echo final prompt
      echo "The element with atomic number $ATOMNUM is $ATOMNAME ($ELSYMB). It's a $ELTYPE, with a mass of $ELMASS amu. $ATOMNAME has a melting point of $ELMELT celsius and a boiling point of $ELBOIL celsius."
    fi
  else
    #check if argument is atomic mass
    ATOMNUM=$($PSQL"SELECT atomic_number FROM elements WHERE atomic_number=$1")
    if [[ -z $ATOMNUM ]]
    then
      #if none return prompt
      echo I could not find that element in the database.
    else
      #set values for name, symbol, type, mass, melting point and boiling point
      ATOMNAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMNUM")
      ELSYMB=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMNUM")
      ELTYPE=$($PSQL "SELECT type FROM properties INNER JOIN types USING(type_id) WHERE atomic_number=$ATOMNUM")
      ELMASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMNUM")
      ELMELT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMNUM")
      ELBOIL=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMNUM")
      #echo final prompt
      echo "The element with atomic number $ATOMNUM is $ATOMNAME ($ELSYMB). It's a $ELTYPE, with a mass of $ELMASS amu. $ATOMNAME has a melting point of $ELMELT celsius and a boiling point of $ELBOIL celsius."
    fi
  fi
fi