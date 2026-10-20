#!/bin/sh

export DOCKER_DEFAULT_PLATFORM=linux/amd64

PROJECT=$(dirname $(readlink -f "$0"))

docker build -t alpine-zip:latest - < "$PROJECT/Dockerfile.zip" || exit 1

if [ -e $PROJECT/target ]; then
    docker run --rm -i -v $PROJECT:/src alpine:latest rm -rf /src/target
fi

# Structure
docker run --rm -i -v $PROJECT:/src -v $PROJECT/target:/target difi/vefa-structure:0.7

# Validator
docker pull ghcr.io/anskaffelser/validator:latest || exit 1
docker run --rm -i -v $PROJECT:/src ghcr.io/anskaffelser/validator:latest build -x -t -n no.difi.ehf.preaward.g2.pacr -a rules -target target/validator /src

# Schematron
for sch in $PROJECT/rules/sch/*.sch; do
    docker run --rm -i -v $PROJECT:/src -v $PROJECT/target/schematron:/target klakegg/schematron prepare /src/rules/sch/$(basename $sch) /target/$(basename $sch)
done
docker run --rm -i -v $PROJECT/target/schematron:/src -v $PROJECT/target/site/files:/target -w /src alpine-zip -r /target/schematron.zip .

# Example files
docker run --rm -i -v $PROJECT/rules/example:/src -v $PROJECT/target/site/files:/target -w /src alpine-zip -r /target/examples.zip .

# Guides
docker run --rm -i -v $PROJECT:/documents -v $PROJECT/target:/target difi/asciidoctor

# Fix ownership
docker run --rm -i -v "$PROJECT:/src" alpine:latest chown -R "$(id -u):$(id -g)" /src/target
