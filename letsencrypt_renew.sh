#!/bin/sh
valid_days=10
letsencrypt_dir=/home/$USER/.config/letsencrypt
cert_dir=${letsencrypt_dir}/live
cert_file='cert.pem'
domain=$(grep -e "[ \t]*domains.*" ~/.config/letsencrypt/cli.ini| sed "s/ //g" |cut -d "=" -f2 | cut -d "," -f1)

if [ "$domain" == "" ]; then
  echo "the 'domains' variable in ${letsencrypt_dir} seems to be malformed or missing."
  echo "Please check this file. (Hint: have you run uberspace-letsencrypt already?)"
  exit 1
fi

# find all certificates
export cert="$(find $cert_dir/$domain/ -iname $cert_file | sort -k1)"

# check certificate validation date
openssl x509 -checkend $(( $valid_days * 86400 )) -in "$cert" > /dev/null

# renew certificates if they are less than only 10 more days valid
if [ $? != 0 ]; then
   letsencrypt certonly -d $domain
   uberspace-prepare-certificate -k $cert_dir/$domain/privkey.pem -c $cert_dir/$domain/$cert_file
fi
