#!/bin/sh
########################################################################
# 2016-02-01 Christian González christian.gonzalez@nerdocs.at
########################################################################
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
#
########################################################################

this="uberspace-mail-tools"

# install SpamAssassin


#install DSPAM
echo "Installing DSPAM service..."
test -d ~/service || uberspace-setup-svscan
test -d ~/etc/dspam-learn && rm -rf ~/etc/dspam-learn
runwhen-conf ~/etc/dspam-learn ~/$this/dspam-learn > /dev/null
sed -i -e "s/^RUNWHEN=.*/RUNWHEN=\",M=`awk 'BEGIN { srand(); printf("%d\n",rand()*60) }'`\"/" ~/etc/dspam-learn/run
ln -sf ~/etc/dspam-learn ~/service


# install DSPAM cleanup service
echo "Installing DSPAM cleanup service..."
test -d ~/service || uberspace-setup-svscan
test -d ~/etc/dspam_clean_hashdb && rm -rf ~/etc/dspam_clean_hashdb
runwhen-conf ~/etc/dspam_clean_hashdb "/usr/local/bin/dspam_clean_hashdb" > /dev/null
sed -i -e "s/^RUNWHEN=.*/RUNWHEN=\",H=`awk 'BEGIN { srand(); printf("%d\n",rand()*24) }'`\"/" ~/etc/dspam_clean_hashdb/run
ln -sf ~/etc/dspam_clean_hashdb ~/service


# install mailfilter file
cp ~/$this/mailfilter.tpl ~/.mailfilter
chmod 600 ~/.mailfilter

# install mailfilter into qmail-default
echo -n "|maildrop" > ~/.qmail-default
