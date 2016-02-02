#!/bin/sh

testuser="test"
# get a mail domain this uberspace is valid for.
domain=`uberspace-list-domains -m |grep -v -e "^*" -m1 |cut -d" " -f1`
echo "used domain for sending emails: $domain"

if [ ! -d ~/users/test ]; then
  echo "adding test user..."
  vadduser --quiet --no-password $testuser
else
  echo "test user already created."
fi

echo -e "deleting all Junk folders..."
rm ~/users/$testuser/.Junk* -rf
rm ~/users/$testuser/.Spam* -rf
rm ~/users/$testuser/.Junk-E-Mail* -rf

echo -e "content of user MailDir:"
ls ~/users/$testuser/ -la | grep -e "Junk\|Spam" || echo "no Junk folders found."

echo -e "\nexecuting maildrop on bogus mail..."
echo | EXT=$testuser maildrop ~/.mailfilter

echo -e "sending test mail to ${testuser}@${domain}"
echo "testcontent" | mail -s TESTMAIL ${testuser}@${domain}

echo -e "content of user MailDir after Junk folder creation:"
ls ~/users/$testuser/ -la | grep -e "Junk\|Spam" || echo "no Junk folders found."

echo -e "\nYou have to delete the $testuser user manually if you don't need it any more."
echo "To do so please just execute"
echo
echo "   vdeluser test"
echo

