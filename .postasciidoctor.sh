#!/bin/sh

if [ -e /target/site ]; then
    mv /target/guide/* /target/site/
else
    mv /target/guide /target/site
fi

find /target/site -name .adocassets -exec rm '{}' \;
