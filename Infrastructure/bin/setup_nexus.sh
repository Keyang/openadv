#!/bin/bash
# Setup Nexus Project
if [ "$#" -ne 1 ]; then
    echo "Usage:"
    echo "  $0 GUID"
    exit 1
fi

GUID=$1
echo "Setting up Nexus in project $GUID-nexus"

# Code to set up the Nexus. It will need to
# * Create Nexus
# * Set the right options for the Nexus Deployment Config
# * Load Nexus with the right repos
# * Configure Nexus as a docker registry
# Hint: Make sure to wait until Nexus if fully up and running
#       before configuring nexus with repositories.
#       You could use the following code:
# while : ; do
#   echo "Checking if Nexus is Ready..."
#   oc get pod -n ${GUID}-nexus|grep '\-2\-'|grep -v deploy|grep "1/1"
#   [[ "$?" == "1" ]] || break
#   echo "...no. Sleeping 10 seconds."
#   sleep 10
# done

# Ideally just calls a template
# oc new-app -f ../templates/nexus.yaml --param .....

# To be Implemented by Student
TMPL=./Infrastructure/templates/nexus.yaml
PROJ=$GUID-nexus

echo "Step 1 -- Setup Nexus server"
oc process -f $TMPL | oc create -n $PROJ -f -
while : ; do
  echo "Checking if Nexus is Ready..."
  oc get pod -n $PROJ | grep -v deploy |grep "1/1.*Running"
  [[ "$?" == "1" ]] || break
  echo "...no. Sleeping 10 seconds."
  sleep 10
done

echo "Step 2 -- Configure Nexus server"
ROUTE=$(oc get route nexus3 --template='{{ .spec.host }}' -n ${PROJ})
echo "Route ${ROUTE}"
sleep 10
./Infrastructure/bin/config_nexus.sh admin admin123 http://${ROUTE}
