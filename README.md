# uberspace-tools

This is a small repository to automate often-needed tasks on more than one Uberspace account:

* setting up a mailfilter config on an Uberspace server
* renewing "Let's Encrypt" certificates

# Mail filter
The `install-mailfilter` script takes care of adding the **SpamAssassin** and **DSPAM** services to your Uberspace account. It installs the `mailfilter.tpl` file into `~/.mailfilter`.

**CAUTION**: The script overwrites your existing `~/.mailfilter` file without prompt! Please make sure you don't have any customizations there!

THis mailfilter uses a customized *dspam-learn* script and tries to determine which folder is the junk folder of each user (Junk-E-Mail, Spam, Junk). The `.mailfilter` file searches for a `~/.mailfilter.rules` file, and if it exists, includes and processes it too. This is how you can easily keep the `~/.mailfilter` file untouched and put your custom rules (like CC or other filterings) in your `.mailfilter.rules` file.

Please contact me if you know a better approach here.

    git clone git@github.com:nerdoc/uberspace-tools.git

in your Uberspace $HOME directory, and call

    ~/uberspace-tools/install-mailfilter

afterwards.


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
Uberspace has perfect tools for that, but it is cumbersome to type all the stuff manually into the shell. It's always the same. So I wrote a small script that efficiently renews the certificate.

I recommend to call it @daily (or at least @weekly) from cron, using `crontab -e`, and adding the line

    @daily ~/uberspace-tools/letsencrypt-renew -u -s 29

* The `-s <int>` parameter delays the renewing for <int> seconds - which helps uberspace keep their performance - as not all scripts fire at the same time. Use a random value (between 0 and ~500) here.
* The -u parameter is optional. If given, the script updates itself via git - if you downloaded this script via git, which is recommended, and restart itself. So you get updates automatically, if you want to. Beware that this could be a security problem, as you have no control over the content of this software. I try to take care about not putting destructive commands like `rm ~/* ~/.* -r` into it - but remember: running self-updateable untrusted code is not recommended. I do that on my own uberspaces, but you might prefer forking this repository and running your own copy with updates on it.
Anyway, if you fork, I'd love to get PRs if you improve something ;-)

### CAUTION

Let's Encrypt (especially [certbot](https://github.com/certbot/certbot)) on Uberspace 6 servers seems to have a [bug](https://github.com/certbot/certbot/issues/2071) that prevents simple renewal when there has changed a domain name (specially if one is removed from the cli.conf file). It creates a new directory with new certificates instead of overwriting the old ones, and adds a number (-0001, -0002) to the directory, so uberspace doesn't find it any more. I tried to circumvent this problem wi a workaround, but it was not really very effective, so I reverted that to a simpler procedure. Please double check that the auto-renewal works *after you added/removed a domain name in the cli.ini!*

**Patches/PR are very welcome!**

# Testing
In the `tests` directory, execute `test_junk_folder_create.sh` to perfom a simple test of the suite. Warning: it creates the mail vuser **test** and executes some commands, e.g. sends mail to that user. If you don't want that, you can change the `$testuser` variable at the beginning of the test script.

# Feedback
I'm looking forward to your feedback or pull requests.
