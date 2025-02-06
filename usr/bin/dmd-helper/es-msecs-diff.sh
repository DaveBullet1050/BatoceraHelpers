#!/bin/bash

# if passed 2 times - each with epoc seconds concatenated with nanoseconds (whole number without decimal)
# will return the difference in seconds and milliseconds
#
# $1 - time 1
# $2 - time 2
#
# Result - $1 minus $2

diff=$((${1} - ${2}))

printf "%s%s" "${diff:0: -9}" "${diff: -9:3}"