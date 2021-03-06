#!/usr/bin/bash

set -e

BASE=$(pwd)
SOURCE_PATH=client
CREDENTIALS=/tmp/credentials/secret

cd $BASE/$SOURCE_PATH
VERSION=$(cat pom.xml | perl -e '$s = 1; while(<>){print $_ if($s); $s=0 if(/parent/); $s=1 if(/\/parent/); }' | perl -ne '/<version>([\d\.]+)(RELEASE)?<\/version>/ && print "$1$2"')

docker tag pandora/client:$VERSION thepandorasys/client:$VERSION

if [ -f  "$CREDENTIALS" ]; then
    REGISTRY_USER=$(cat $CREDENTIALS | perl -ne 'print $_ if($. == 1)')
    REGISTRY_PASSWORD=$(cat $CREDENTIALS | perl -ne 'print $_ if($. == 2)')
    echo $REGISTRY_PASSWORD | docker login -u $REGISTRY_USER --password-stdin
    docker push thepandorasys/client:$VERSION
else
    echo "It won't push the images because there is no credentials folder"
fi

