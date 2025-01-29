#!/bin/bash

# This script demonstrates a race condition bug.

# Create two files
touch file1.txt
touch file2.txt

# Start two background processes that write to the files concurrently
(while true; do echo "Process 1" >> file1.txt; sleep 1; done) &
(while true; do echo "Process 2" >> file2.txt; sleep 1; done) &

# Wait for a few seconds to allow some data to be written
sleep 5

# Try to concatenate the files. The output may be incomplete or corrupted due to the race condition.
cat file1.txt file2.txt

# Stop the background processes
kill %1
kill %2

# Remove temporary files
rm file1.txt file2.txt