#!/bin/sh

this="mail-tools"

# install SpamAssassin


#install DSPAM

test -d ~/service || uberspace-setup-svscan
runwhen-conf ~/etc/dspam-learn "~/$this/dspam-learn"
sed -i -e "s/^RUNWHEN=.*/RUNWHEN=\",M=`awk 'BEGIN { srand(); printf("%d\n",rand()*60) }'`\"/" ~/etc/dspam-learn/run
ln -sf ~/etc/dspam-learn ~/service


# install DSPAM cleanup service
test -d ~/service || uberspace-setup-svscan
runwhen-conf ~/etc/dspam_clean_hashdb "/usr/local/bin/dspam_clean_hashdb"
sed -i -e "s/^RUNWHEN=.*/RUNWHEN=\",H=`awk 'BEGIN { srand(); printf("%d\n",rand()*24) }'`\"/" ~/etc/dspam_clean_hashdb/run
ln -sf ~/etc/dspam_clean_hashdb ~/service


# install mailfilter file
cp ~/$this/mailfilter.tpl ~/.mailfilter
