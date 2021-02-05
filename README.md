# Login to Openshift
oc login --token=
ME=$(oc whoami)

# Set up the Jenkins namespace
oc new-project $ME-jenkins
oc new-app --as-deployment-config jenkins-ephemeral
oc create -f build-config.yaml

# Set up 
oc new-project $ME-python-acc
oc policy add-role-to-user  edit system:serviceaccount:$ME-jenkins:jenkins  -n $ME-python-acc

# Configure Openshift Jenkins Sync 
- Login to Jenkins
- Manage Jenkins > Configure System > OpenShift Jenkins Sync
- Add the value for $ME-python-acc in the namespace field
