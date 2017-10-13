#!/bin/sh

cd `dirname $0`
git ull > /dev/null || echo "ERROR: Could not update the uberspace-tools directory via 'git pull'!"
