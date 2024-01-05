# moonphase.sh

A simple bash script to display the moon phase, today or on some 
specific date.

# Usage

    moonphase.sh ["date string"]

Don't forget the quotation marks if the date string contains spaces.

The output shows the moon phases as a percentage and name. For example: 

    $ moonphase.sh "jan 28 2023"
    Jan 28 2023: 19%, first quarter

The date string is anything that can be parsed by the `date` utility,
which is locale-specific. If no date is given, the utility assumes
today.

# How it works

To a good approximation, there is a fixed, known time between corresponding
moon phases. The 'synodic month' is the time in Earth days between 
corresponding phases. It's about 29.5 days. The value used in the 
calculation is 2551443 seconds. 

The utility knows the exact moon phase at some reference time. It doesn't
matter what that reference time is, but it shouldn't be too far in the 
future or the past. The default is Jan 15, 2023, when the moon was at
0.75, third quarter. It doesn't matter what moon phase is used, so long
as it's known exactly. The accuracy of the final result depends critically
on the accuracy of this reference value. 

We use the GNU `date` utility to convert the selected date and the
reference date to Unix epoch times. These are times in seconds after the
beginning of 1970, but the details are unimportant -- we just subtract
the to epoch time to get the time in seconds between the selected time
and the reference time.

Then we just divide this time difference by the synodic month in seconds,
to get the number of moon phases in the elapsed time. We then multiply this
figure by 100, and add it to the reference phase, which is a percentage. 
This result might be greater than 100%, because the elapsed time might be
many moons. However, moon phases are cyclic, so we just reduce the result
modulo 100%, to get the final result as a percentage.

We then display the percentage along with a string representation of the
moon phase. The program recognizes eight phases: new, waxing crescent, etc.
So we divide the 100% range of the moon cycle into eight blocks of 
100/8%=12.5%, centered on the full moon at 50%

# Accuracy

The calculation is not perfect, by any means. I've compared it with the
results at timeanddate.com, and the results match pretty well in the time
range 2023-2026. The main source of error are probably

- the use of integer arithmetic throughout. I've used the standard
  `expr` utility to do the math, which only works with integers, as does
  the bash shell itself;
- the duration of the synodic month itself is only an average, as the 
  moon's orbit of the Earth is subject to small gravitational fluctuation;
- the reference time is only given as a date, but moon phases occur at
  specific points in time. There's little point striving for better 
  accuracy in this area, because published moon tables do not give
  sufficient detail.

# Legal and copying

`moonphase.sh` is Copyright Kevin Boone (c)2024, released under the terms
of the GNU Public Licence, version 3. It's just an educational example
that demonstrates specific aspects of bash shell programming -- please don't
use it for anything critical. 


