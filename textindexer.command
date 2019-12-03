#!/bin/bash
echo ""
echo ""
echo "Welcome to the XTF workshop!"
echo ""
echo "Indexation…"
sleep 1
clear
export XTFWS=`/usr/bin/dirname "$0"`
export XTF_HOME="$XTFWS/tomcat/webapps/xtf"
cd "$XTFWS"
"$XTF_HOME/bin/textIndexer" -index default
