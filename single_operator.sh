#!/bin/bash -e

OCP_VERSION="4.7"
# redhat, certified, community
CATALOG="redhat"
#CATALOG="certified"
#CATALOG="community"
OPERATORS="elasticsearch-operator"
REGISTRY="bastion.danclark.io:5000"
DIR="/opt/openshift/mirror"
PULL_SECRET="/home/ec2-user/pull-secret.txt"

for operator in ${OPERATORS}
do

  rm -rf ./publish
  rm -rf ${DIR}
  mkdir ${DIR}

  ./mirror-operator-catalogue.py \
    --authfile ${PULL_SECRET} \
    --ocp-version ${OCP_VERSION} \
    --operator-channel ${OCP_VERSION} \
    --operator-catalog-image-url registry.redhat.io/redhat/${CATALOG}-operator-index \
    --operator-list ${operator} \
    --custom-operator-catalog-image-and-tag redhat/${operator}-catalog:v${OPERATOR_VERSION} \
    --registry-olm ${REGISTRY} \
    --registry-catalog ${REGISTRY} \
    --to-dir=${DIR} \

  OPERATOR_VERSION=$(grep Version ./publish/mirror_log.txt | awk '{print $NF}' | tr -d ']')

  tar -czf "${operator}-${OPERATOR_VERSION}-mapping.tgz" ./publish
  rm -rf publish
  tar -cf "${operator}-${OPERATOR_VERSION}-images.tar" "${DIR}"
  rm -rf "${DIR}"

done

exit 0
