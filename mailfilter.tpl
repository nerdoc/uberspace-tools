########################################################################
# Original code from https://wiki.uberspace.de/mail:maildrop
# 2016-02-01 Christian González christian.gonzalez@nerdocs.at
########################################################################
#
# This file is part of the uberspace-tools suite.
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

# WARNING: This file is auto-generated. All customizations will be lost
# if you run 'install-mailfilter' again.
# Please put any custom rules into ~/mailfilter.rules

MAXSPAMSCORE="3"
logfile "$HOME/mailfilter.log"

# set default Maildir
MAILDIR="$HOME/Maildir"

# check if we're called from a .qmail-EXT instead of .qmail
import EXT
if ( $EXT )
{
  # does a vmailmgr user named $EXT exist?
  # if yes, deliver mail to his Maildir instead
  CHECKMAILDIR = `dumpvuser $EXT | grep '^Directory' | awk '{ print $2 }'`
  if ( $CHECKMAILDIR )
  {
    MAILDIR="$HOME/$CHECKMAILDIR"
  }
}

# check folder structure

# test for junk directory.
# Thunderbird + all open source/ de-facto standard style is "Junk"
JUNKDIR=".Junk"

# Outlook style
`test -d "$MAILDIR/.Junk-E-Mail"`
if( $RETURNCODE == 0 )
{
  JUNKDIR=".Junk-E-Mail"
}
else
{
  # Gmail style
  `test -d "$MAILDIR/.Spam"`
  if( $RETURNCODE == 0 )
  {
    JUNKDIR=".Spam"
  }
  else
  {
    # Thunderbird and de-facto standard
    `test -d "$MAILDIR/.Junk"`
    if( $RETURNCODE == 0 )
    {
      JUNKDIR=".Junk"
    }
  }
}
# now test if any Junkdir exists already
`test -d "$MAILDIR/$JUNKDIR"`
if( $RETURNCODE == 1 )
{
  `maildirmake "$MAILDIR/$JUNKDIR"`
}

`test -d "$MAILDIR/$JUNKDIR.als Spam lernen"`
if( $RETURNCODE == 1 )
{
  `maildirmake "$MAILDIR/$JUNKDIR.als Spam lernen"`
}
`test -d "$MAILDIR/$JUNKDIR.als Ham lernen"`
if( $RETURNCODE == 1 )
{
  `maildirmake "$MAILDIR/$JUNKDIR.als Ham lernen"`
}

# show the mail to SpamAssassin
xfilter "/usr/bin/spamc"

# now show the mail to DSPAM
xfilter "/package/host/localhost/dspam/bin/dspam --mode=teft --deliver=innocent,spam --stdout"

f ( ! /^X-DSPAM-Result: Whitelisted/)
{
  if ( /^X-Spam-Level: \*{$MAXSPAMSCORE,}$/ || /^X-DSPAM-Result: Spam/)
  {
    log "DSPMA: Spam detected:"
    MAILDIR="$MAILDIR/$JUNKDIR"
    # mark as read
    cc "$MAILDIR";
    `find "$MAILDIR/new/" -mindepth 1 -maxdepth 1 -type f -printf '%f\0' | xargs -0 -I {} mv "$MAILDIR/new/{}" "$MAILDIR/cur/{}:2,S"`
    exit
  }
}
else
{
  log "DSPAM: Whitelisted:"
}


# Then look for a local ".mailfilter.rules" file, and include it if it exists
# You can add some custom filters there without touching this file here
`test -f "$HOME/.mailfilter.rules"`
if( $RETURNCODE == 0 )
{
  include "$HOME/.mailfilter.rules"
}

# and finally, deliver everything that survived our filtering
to "$MAILDIR"
