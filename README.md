# uberspace-mail-tools

This is a small repository to automate the often-needed task setting up a mailfilter config on an uberspace server.

The `install-mailfilter.sh script` takes care of adding the **SpamAssassin** and **DSPAM** services to your uberspace account. It installs the `.mailfilter` file into place and uses a customized *dspam-learn* and mailfilter script that tries to determine which folder is the junk folder of each user (Junk-E-Mail, Spam, Junk).

You can simply do a

    clone git@github.com:nerdoc/uberspace-mail-tools.git

in your uberspace $HOME directory, and call

    sh ~/uberspace-mail-tools/install-mailfilter.sh

afterwords.


Feel free to give feedback or provide pull requests.
