# uberspace-tools

This is a small repository to automate often-needed tasks on more than one uberspace accounts.

* setting up a mailfilter config on an uberspace server.
* renewing LetsEncrypt certificates

The `install-mailfilter.sh script` takes care of adding the **SpamAssassin** and **DSPAM** services to your uberspace account. It installs the `.mailfilter` file into place and uses a customized *dspam-learn* and mailfilter script that tries to determine which folder is the junk folder of each user (Junk-E-Mail, Spam, Junk).

You can simply do a

    clone git@github.com:nerdoc/uberspace-tools.git

in your uberspace $HOME directory, and call

    sh ~/uberspace-tools/install-mailfilter.sh

afterwards.

# Junk folder

There is no real standardized name for the IMAP junk folder in the net. Different email programs use different names, e.g.

  * Outlook: *Junk-E-Mail*
  * GMail: *Spam*
  * Thunderbird & many others: *Junk*

So I decided to include a small check in the scripts and determine the directory at each user's Maildir individually. If *Junk-E-Mail* is found, it is used. Then *Spam*, then *Junk* is tested. If nothing is found, I decided to use *Junk*. This is because of two reasons:
  * I think "Junk" is the mostly used one. YMMV.
  * I think Thunderbird, as open source software, deserves some respect and should be promoted.

# Testing
in the *tests* directory, execute `test_junk_folder_create.sh` for a simple suite testing. Warning: it creates the mail vuser **test** and executes some commands, e.g. sends mail to that user. If you don't want that, you can change the `$testuser` variable at the beginning of the test script.

# Feedback
Feel free to give feedback or provide pull requests.
