#!/bin/bash

PSQL="psql -X --username=freecodecamp -d periodic_table --tuples-only -c"


if [[ ! $1 ]]
then
	echo -e "Please provide an element as an argument."
elif [[ $1 =~ ^[0-9]+$ ]]
then
	ELEMENT_INFO=$($PSQL "select atomic_number,name,symbol,type,atomic_mass,melting_point_celsius,boiling_point_celsius from elements inner join properties using (atomic_number) inner join types using (type_id) where atomic_number='$1'")
else
	ELEMENT_INFO=$($PSQL "select atomic_number,name,symbol,type,atomic_mass,melting_point_celsius,boiling_point_celsius from elements inner join properties using (atomic_number) inner join types using (type_id) where name='$1' or symbol='$1'")
fi

if [[ -n $ELEMENT_INFO ]]
then
	echo $ELEMENT_INFO | while IFS=" |" read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS
	do
		echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
	done
elif [[ $1 ]]
then
	echo "I could not find that element in the database."
fi
