#!/bin/bash
# Setup Development Project
if [ "$#" -ne 1 ]; then
    echo "Usage:"
    echo "  $0 GUID"
    exit 1
fi

GUID=$1
echo "Setting up Parks Development Environment in project ${GUID}-parks-dev"

# Code to set up the parks development project.

# To be Implemented by Student
PROJ=${GUID}-parks-dev
MONGO_TMPL=./Infrastructure/templates/mongo.yaml
APPS_TMPL=./Infrastructure/templates/dev_apps.yaml

echo "Step 1 -- Create mongodb"
oc create -f $MONGO_TMPL -n $PROJ

./Infrastructure/bin/waitPodReady.sh mongodb $PROJ

echo "Step 2 -- Setup 3 apps"
oc create -f $APPS_TMPL -n $PROJ