#!/bin/sh
valid_days=10
cert_dir=/home/$USER/.config/letsencrypt/live
cert_file='cert.pem'
domain=$(grep -e "[ \t]*domains.*" ~/.config/letsencrypt/cli.ini| sed "s/ //g" |cut -d "=" -f2 | cut -d "," -f1)


# find all certificates
export cert="$(find $cert_dir/$domain/ -iname $cert_file | sort -k1)"

# check certificate validation date
openssl x509 -checkend $(( $valid_days * 86400 )) -in "$cert" > /dev/null

# renew certificates if they are less than only 10 more days valid
if [ $? != 0 ]; then
   letsencrypt certonly
   uberspace-prepare-certificate -k $cert_dir/$domain/privkey.pem -c $cert_dir/$domain/$cert_file
fi
