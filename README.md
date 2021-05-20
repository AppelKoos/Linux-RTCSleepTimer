# Linux-RTCSleepTimer

Uses rtcwake to suspend a linux machine until the specified time.
By default the script looks for the next day or the same day dependant on time called and suspends the session to memory.

# Usage
The script was made to be used in cron. Feel free to modify to suite your automation needs

- [scriptname] [HH] [MM]

- ex.' sleep_timer.sh 07 23 '

# Notes

This was tested and created for fedora but I do not see how this won't work on other distro's so feel free to try.
