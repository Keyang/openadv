#!/bin/bash
# Setup Production Project (initial active services: Green)
if [ "$#" -ne 1 ]; then
    echo "Usage:"
    echo "  $0 GUID"
    exit 1
fi

GUID=$1
echo "Setting up Parks Production Environment in project ${GUID}-parks-prod"

# Code to set up the parks production project. It will need a StatefulSet MongoDB, and two applications each (Blue/Green) for NationalParks, MLBParks and Parksmap.
# The Green services/routes need to be active initially to guarantee a successful grading pipeline run.

# To be Implemented by Student
PROJ=${GUID}-parks-prod
MONGO_TMPL=./Infrastructure/templates/mongo-rs.yaml
APPS_TMPL=./Infrastructure/templates/prod_apps.yaml

echo "Step 1 -- Create mongodb replica set with 3 instances"
oc create -f $MONGO_TMPL -n $PROJ

./Infrastructure/bin/waitPodReady.sh mongodb-0 $PROJ
./Infrastructure/bin/waitPodReady.sh mongodb-1 $PROJ
./Infrastructure/bin/waitPodReady.sh mongodb-2 $PROJ

echo "Step 2 -- Setup 3 apps for production"
# Setup 5 dc
# Setup 7 svc
# setup 3 imagestreams
# setup 5 routes

oc create -f $APPS_TMPL -n $PROJ

echo "Step 3 -- Add view permission to prod sa group"
oc policy add-role-to-group view system:serviceaccount:kxiang-parks-prod -n ${GUID}-parks-dev
oc policy add-role-to-user view --serviceaccount=default -n $PROJ