#!/bin/bash -e

OCP_VERSION="4.9"
# redhat, certified, community
CATALOG="redhat"
#CATALOG="certified"
#CATALOG="community"
OPERATORS="advanced-cluster-management aws-efs-csi-driver-operator cincinnati-operator cluster-logging compliance-operator container-security-operator file-integrity-operator elasticsearch-operator local-storage-operator nfd ocs-operator openshift-gitops-operator openshift-special-resource-operator openshift-pipelines-operator-rh openshift-jenkins-operator quay-bridge-operator quay-operator rhacs-operator rhsso-operator"
REGISTRY="bastion.danclark.io:5000"
DIR="/opt/openshift/mirror"
PULL_SECRET="/home/ec2-user/pull-secret.txt"

for operator in ${OPERATORS}
do

  ./mirror-operator-catalogue.py \
    --authfile ${PULL_SECRET} \
    --ocp-version ${OCP_VERSION} \
    --operator-channel ${OCP_VERSION} \
    --operator-catalog-image-url registry.redhat.io/redhat/${CATALOG}-operator-index \
    --operator-list ${operator} \
    --custom-operator-catalog-image-and-tag redhat/${operator}-catalog:v${OCP_VERSION} \
    --registry-olm ${REGISTRY} \
    --registry-catalog ${REGISTRY} \
    --to-dir=${DIR} \
    --mirror-images false

  OPERATOR_VERSION=$(grep Version ./publish/mirror_log.txt | awk '{print $NF}' | tr -d ']')
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

  tar -czf "${operator}-${OPERATOR_VERSION}-mapping.tgz" ./publish
  rm -rf publish
  tar -cf "${operator}-${OPERATOR_VERSION}-images.tar" "${DIR}"
  rm -rf "${DIR}"

done

exit 0
