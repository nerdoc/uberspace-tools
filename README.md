# uberspace-tools

This is a small repository to automate often-needed tasks on more than one Uberspace account:

* setting up a mailfilter config on an Uberspace server
* renewing "Let's Encrypt" certificates

# Mail filter
The `install-mailfilter.` script takes care of adding the **SpamAssassin** and **DSPAM** services to your Uberspace account. It installs the `.mailfilter` file into place and uses a customized *dspam-learn* and mailfilter script that tries to determine which folder is the junk folder of each user (Junk-E-Mail, Spam, Junk).

You can simply do a

    git clone git@github.com:nerdoc/uberspace-tools.git

in your Uberspace $HOME directory, and call

    ~/uberspace-tools/install-mailfilter

afterwards.

**CAUTION**: The script overwrites your existing `~/.mailfilter` file without prompt! Please make sure you don't have any customizations there!

### Junk folder

There is no real standardized name for the IMAP junk folder on the net. Different email programs use different names, e.g.

  * Outlook: *Junk-E-Mail*
  * GMail: *Spam*
  * Thunderbird & many others: *Junk*

So I decided to include a small check in the scripts and determine the directory at each user's Maildir individually. If *Junk-E-Mail* is found, it is used. Then *Spam*, then *Junk* is tested. If nothing is found, I decided to use *Junk*. This is because of two reasons:
  * I think "Junk" is the mostly used one. YMMV.
  * I think Thunderbird, as open source software, deserves some respect and should be promoted.

# Let's Encrypt - Auto-Renewer

Let's Encrypt does invalidate your certificates after 90days ATM. This is no problem as long as you renew the certificate within that period.
Uberspace has perfect tools for that, but it is cumbersome to type all the stuff manually into the shell. It's always the same. So I
wrote a small script that efficiently renews the certificate.

I recommend to call it @weekly (@daily is no problem neither) from cron, using `crontab -e`, and adding the line

    @weekly ~/uberspace-tools/letsencrypt-renew -s 29

* The `-s <int>` parameter delays the renewing for <int> seconds - which helps uberspace kepp their performance - as not all scripts fire
at the same time. Use a random value (between 0 and ~500) here.

# Testing
In the `tests` directory, execute `test_junk_folder_create.sh` to perfom a simple test of the suite. Warning: it creates the mail vuser **test** and executes some commands, e.g. sends mail to that user. If you don't want that, you can change the `$testuser` variable at the beginning of the test script.

# Feedback
Feel free to give feedback or provide pull requests.
