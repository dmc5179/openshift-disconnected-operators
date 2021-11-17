#!/bin/bash

REGISTRY="myregistry.com:5000"

if test -z "${1}"
then
  echo "Usage: $0 <base registry url; i.e myregistry.com:5000>"
  exit 1
fi

sed -i "s|file://|${1}|g" publish/olm-icsp.yaml
