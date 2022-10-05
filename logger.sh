# Author: KaptainJosh
# Description: This script monitors who logs in and logs out of the current machine that this script is running on.

#! /bin/bash

# The block below traps the ^C input one time then resets it
suppress()
{
        echo " (SIGINT) ignored. Enter ^C 1 more time to terminate program."
        trap 2
}

trap 'suppress' 2

# This code outputs the initial list of users
who > log1.txt # Saves initial users in a log file (log1.txt will be used to represent current users)
echo `date`
echo Initial users logged in:
hostname=`hostname` # Holds value of the hostname to be used in the printf statements
gawk -v host=$hostname '{ printf "> %s logged in to %s \n", $1, host }' log1.txt # Printing out initial list of users
cat log1.txt > log2.txt #copying current users to log2.txt (log2.txt will be used to represent the users logged in at the last check)

# The while loop below runs the program to check who logged in and out till the user uses ^C twice.
while true
	do
		echo "`date` |  # of users: `who | wc -l`" #Outputs date and number of users
		who > log1.txt
		diff log2.txt log1.txt > log3.txt #evaluates if there are any differences between who was logged in before and who was logged in now
		gawk -v host=$hostname '/>/ {printf "> %s logged in to %s \n", $2, host}' log3.txt # If there are more users in log1.txt than log2.txt then a new user logged in
		gawk -v host=$hostname '/</ {printf "> %s logged out of %s \n", $2, host}' log3.txt #If there are less users in log1.txt than log2.txt then a user logged out
		cat log1.txt > log2.txt

		sleep 10 # Wait 10 seconds before repeating again
	done

