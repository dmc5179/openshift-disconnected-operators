#!/bin/bash

OCP_VERSION="4.8"
# redhat, certified, community
CATALOG="redhat"
OPERATOR="compliance-operator"
REGISTRY="bastion.danclark.io:5000"
DIR="/opt/openshift/mirror"

./mirror-operator-catalogue.py \
  --authfile /opt/openshift/pull-secret.txt \
  --ocp-version ${OCP_VERSION} \
  --operator-channel ${OCP_VERSION} \
  --operator-catalog-image-url registry.redhat.io/redhat/${CATALOG}-operator-index \
  --operator-list ${OPERATOR} \
  --custom-operator-catalog-image-and-tag redhat/${OPERATOR}-catalog:v${OCP_VERSION} \
  --registry-olm ${REGISTRY} \
  --registry-catalog ${REGISTRY} \
  --to-dir=${DIR} \
  --mirror-images false

OPERATOR_VERSION=$(grep Version ./publish/mirror_log.txt | awk '{print $NF}' | tr -d ']')
rm -rf ./publish
rm -rf ${DIR}
mkdir ${DIR}

./mirror-operator-catalogue.py \
  --authfile /opt/openshift/pull-secret.txt \
  --ocp-version ${OCP_VERSION} \
  --operator-channel ${OCP_VERSION} \
  --operator-catalog-image-url registry.redhat.io/redhat/${CATALOG}-operator-index \
  --operator-list ${OPERATOR} \
  --custom-operator-catalog-image-and-tag redhat/${OPERATOR}-catalog:v${OPERATOR_VERSION} \
  --registry-olm ${REGISTRY} \
  --registry-catalog ${REGISTRY} \
  --to-dir=${DIR} \

tar -czf "${OPERATOR}-${OPERATOR_VERSION}-mapping.tgz" ./publish
rm -rf publish
tar -cf "${OPERATOR}-${OPERATOR_VERSION}-images.tar" "${DIR}"
rm -rf "${DIR}"
