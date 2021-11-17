#!/bin/bash

REGISTRY="myregistry.com:5000"

if test -z "${1}"
then
  echo "Usage: $0 <base registry url; i.e myregistry.com:5000>"
  exit 1
fi

DST=$(grep -A 1 -m 1 mirrors publish/olm-icsp.yaml | tail -1 | tr -d ' ' | tr -d '-' | cut -d\/ -f1)

sed -i "s|${DST}|${1}|g" publish/olm-icsp.yaml
sed -i 's|///|/|g' publish/olm-icsp.yaml
sed -i 's|//|/|g' publish/olm-icsp.yaml
