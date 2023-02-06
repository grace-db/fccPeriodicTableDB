#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --tuples-only -c"

# if argument is null
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

# if argument is not a number
if [[ ! $1 =~ ^[0-9]+$ ]]
then
  ELEMENT_SELECTED=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE name='$1' OR symbol='$1'")
else
  # argument is atomic number
  ELEMENT_SELECTED=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE atomic_number='$1'")
fi

# if not available
if [[ -z $ELEMENT_SELECTED ]]
then
  echo "I could not find that element in the database."
  exit
fi

echo $ELEMENT_SELECTED | while IFS=" |" read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS
do
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
done
