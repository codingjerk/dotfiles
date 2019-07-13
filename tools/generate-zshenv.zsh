rg 'DEFAULT' ~/.pam_environment | awk -F'[= ]' '{print "export " $1 "=" "\"" $3 "\""}'
