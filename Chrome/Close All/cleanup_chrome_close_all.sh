#!/bin/bash

# Close Chrome and Chrome-Beta, both executable files are called "chrome"
echo "Attempting to kill Chrome at $(date)" >> ~/.chrome_logout.log
killall chrome 2>&1 >> ~/.chrome_logout.log
echo "Chrome kill attempt finished." >> ~/.chrome_logout.log