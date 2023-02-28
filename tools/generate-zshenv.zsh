grep 'DEFAULT' | awk -F'[= ]' '{print "export " $1 "=" "\"" $3 "\""}'
