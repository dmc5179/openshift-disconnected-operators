#!/bin/bash

for line in $(cat publish/mapping.txt)
do

SRC=$(echo "$line" | awk -F= '{print $1}')
DST=$(echo "$line" | awk -F= '{print $2}')

if [[ $SRC =~ '@' ]]
then
  TAG="@$(echo "${SRC}" | awk -F\@ '{print $2}')"
  IMG="$(echo "${SRC}" | awk -F\@ '{print $1}' | cut -d / -f2-)"
else
  TAG=":$(echo "${SRC}" | awk -F\: '{print $2}')"
  IMG="$(echo "${SRC}" | awk -F\: '{print $1}' | cut -d / -f2-)"
fi


#echo "SRC: $SRC"
#echo "DST: $DST"
#echo "TAG: $TAG"

echo "${DST}${TAG}=${1}/${IMG}"

done

