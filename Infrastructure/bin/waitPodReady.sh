#!/bin/bash
echo "Wait Pod with name ${1} in Project ${2}"
sleep 5
while : ; do
  echo "Checking if ${1} is Ready..."
  oc get pod -n $2 | grep $1 | grep -v deploy |grep "1/1.*Running"
  [[ "$?" == "1" ]] || break
  echo "...no. Sleeping 10 seconds."
  sleep 10
done