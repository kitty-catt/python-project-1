# Login to Openshift

    oc login --token=
    ME=$(oc whoami)

# Set up the Jenkins namespace

    oc new-project $ME-jenkins
    oc new-app --as-deployment-config jenkins-ephemeral
    oc create -f build-config.yaml

# Set up dev namespace

    oc new-project $ME-python-dev
    oc policy add-role-to-user  edit system:serviceaccount:$ME-jenkins:jenkins  -n $ME-python-dev

    export OCP_USER=$(oc whoami)
    export OCP_TOKEN=$(oc whoami -t)

    oc policy add-role-to-user registry-viewer $OCP_USER
    oc adm policy add-role-to-user registry-editor $OCP_USER
    cd jmeter-image
    docker build -t jmeter-image .
    cd ..

    # Make the initial configmap by hand, ... the pipeline will replace it.
    oc create configmap apt-test --from-file=jmeter-tests   

# Push out to quay

    docker login -u kitty_catt quay.io
    docker tag jmeter-image quay.io/kitty_catt/jmeter-image
    docker push quay.io/kitty_catt/jmeter-image

# Or push out to the openshift cluster (replace the application load balancer address):

    APLB="apps.eu45.prod.nextcle.com"
    docker login -u $(oc whoami) -p $(oc whoami -t) default-route-openshift-image-registry.$APLB
    docker tag jmeter-image default-route-openshift-image-registry.$APLB/$ME-python-dev/jmeter-image
    docker push default-route-openshift-image-registry.$APLB/$ME-python-dev/jmeter-image

# Check

    $ oc get is
    NAME           IMAGE REPOSITORY                                                                                    TAGS     UPDATED
    jmeter-image   default-route-openshift-image-registry.apps.eu45.prod.nextcle.com/XXXX-python-dev/jmeter-image   latest   22 seconds ago

# Set up acc namespace

    oc new-project $ME-python-acc
    oc policy add-role-to-user  edit system:serviceaccount:$ME-jenkins:jenkins  -n $ME-python-acc

# Configure Openshift Jenkins Sync 

    - Login to Jenkins
    - Manage Jenkins > Configure System > OpenShift Jenkins Sync
    - Add the value for $ME-python-dev and $ME-python-acc in the namespace field

# Start build

The pipeline runs automatically once per day. The time and frequency is controlled in the Jenkinsfile.


# Appendix A - deploy by hand

oc new-app --name=python1 --as-deployment-config https://github.com/kitty-catt/python-project-1#v2
oc expose svc python1

