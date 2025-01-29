#!/bin/bash

# This script demonstrates a solution to the race condition using flock.

# Create two files
touch file1.txt
touch file2.txt

# Define a lock file
lock_file="my_lock"

# Process 1
(while true; do
  flock -n $lock_file || exit 1  #Try to acquire lock; exit if failed
  echo "Process 1" >> file1.txt
  flock -u $lock_file  #Unlock file
  sleep 1
done) &

# Process 2
(while true; do
  flock -n $lock_file || exit 1
  echo "Process 2" >> file2.txt
  flock -u $lock_file
  sleep 1
done) &

# Wait for a few seconds to allow some data to be written
sleep 5

# Concatenate the files; output should be orderly now.
cat file1.txt file2.txt

# Stop the background processes
kill %1
kill %2

# Remove temporary files
rm file1.txt file2.txt
rm $lock_file