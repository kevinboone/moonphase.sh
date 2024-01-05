#!/bin/bash
#
# moonphase.sh
#
# A bash script to display the moon phase, today or on some selected
#   date.
# 
# Usage: moonphase.sh ["date string"]
# For example: moonphase.sh "jan 26 2026"
# Don't forget the quotation marks if the date string contains spaces
#
# Copyright (c)2024 Kevin Boone, GPL 3

# ===== Reference date and phase =====

# We must specify the moon phase on some specific date, not too far in the
#   future or the past.
# New moon is 0, full is 50, first quarter 25, third quarter 75.
# Note that we're just giving a date, not a date/time, so we'll get the time 
#   at midnight. This is a small source of error, as moon phases occur at
#   particular times, not just particular dates. But the error is tolerable 
#   in this simple application.
REF_DATE="Jan 15 2023"
REF_PERCENT=75

# ==== Constants =====

SEC_PER_DAY=86400
# SYNODIC_SECONDS is the averagenumber of seconds between new moons, 
# as seen from the earth. It's about 29.5 days. 
SYNODIC_SECONDS=2551443

# ==== Calculation starts here =====

# Convert the reference date to a Unix epoch time in seconds. 
REF_EPOCH=`date --date "$REF_DATE" +%s`

# Convert the calculation date to a Unix epoch time in seconds.
# We'll also store a displayable form of the date, just for 
#   display purposes 
if [[ -z "$1" ]] ; then
  NOW_EPOCH=`date +%s`
  NOW_DISPLAY=`date "+%b %d %Y"`
else
  NOW_EPOCH=`date +%s --date "$1"`
  NOW_DISPLAY=`date +"%b %d %Y" --date "$1"`
fi

# Calculate the number of seconds between the current time and the reference
#   time.
SEC_DIFF=$(($NOW_EPOCH - $REF_EPOCH))

# What's a centi-moon? It's 100 times the fraction of the synodic month
#   represented by the time difference beween current and reference times.
# That is, if the time difference is exactly one synodic month, that's
#   100 'centi-moons'. I'm using this way of representing the moon phase
#   because (a) we're representing the moon phase as a percentage anyway
#   and (b) because bash can't do floating-point math. 
CENTI_MOONS=$((100 * $SEC_DIFF / $SYNODIC_SECONDS))

# To get the current phase, add the time offset in 'centi-moons' to the
#   reference phase (which is a percentage). Because this addition might
#   exceed 100%, we'll reduce it modulo 100 to keep it in the 0-99 range.
MOON_PERCENT=$((($CENTI_MOONS + $REF_PERCENT) % 100))

# ==== Display =====

# Display the calulated moon phase. There are eight named phases, so
#   each occupies 12.5% of the total synodic month. Full moon, for example,
#   is exactly 50%; but we'll take values 44%-57% as full. Strictly it
#   should be 43.75 to 56.25, but the error created in working with
#   whole-number percentages is not significant here. 
echo -n "$NOW_DISPLAY: "
echo -n "$MOON_PERCENT%, "
if [[ $MOON_PERCENT -lt 7 ]] ; then
  echo "new"
elif [[ $MOON_PERCENT -lt 19 ]] ; then
  echo "waxing crescent"
elif [[ $MOON_PERCENT -lt 32 ]] ; then
  echo "first quarter"
elif [[ $MOON_PERCENT -lt 44 ]] ; then
  echo "waxing gibbous"
elif [[ $MOON_PERCENT -lt 57 ]] ; then
  echo "full"
elif [[ $MOON_PERCENT -lt 69  ]] ; then
  echo "waning gibbous"
elif [[ $MOON_PERCENT -lt 82 ]] ; then
  echo "third quarter"
elif [[ $MOON_PERCENT -lt 94 ]] ; then
  echo "waning crescent"
else
  echo "new"
fi


