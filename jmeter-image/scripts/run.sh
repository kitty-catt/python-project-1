#!/bin/bash

echo "ENVIRONMENT:"
#E=$(env)
#for FIL in $E; do echo "- $FIL"; done
echo "PLAN_SUB_DIR $PLAN_SUB_DIR"
echo "RESULT_SUB_DIR $RESULT_SUB_DIR"

A=$(find /opt/jmeter/tests -name "*.jmx")
for FIL in $A; do echo "found jmx plan: $FIL"; done

# Dateformat: %Y-%m-%d_%H:%M:%S
#dir=${RESULT_SUB_DIR:-$(date +"%F_%T")}

# Parse JMeter parameters, replaces the J_ in J_PARAM with -J -> -JPARAM
for param in $(printenv | grep J_); do
    JMETER_PARAMS="$JMETER_PARAMS -J${param:2}"
done

# Runs tests from JMX file, creates results file and reports dashboard
PLAN_DIR=$JMETER_BASE/tests/$PLAN_SUB_DIR
echo "PLAN_DIR $PLAN_DIR"
ls -lrt $PLAN_DIR

for TEST_FILE in $PLAN_DIR/*.jmx; do
    echo "IN: $TEST_FILE"
    RESULT_FILE=/opt/jmeter/results/$(basename $TEST_FILE .jmx).jtl
    echo "OUT: $RESULT_FILE"
    $JMETER_HOME/bin/jmeter -n -t $TEST_FILE -l $RESULT_FILE $JMETER_PARAMS
done

echo "END RESULTS:"
wc -l /opt/jmeter/results/*.jtl
echo

echo "ERRORS:"
grep "false" /opt/jmeter/results/*.jtl
echo

echo "DETAILS:"
cat /opt/jmeter/results/*.jtl
echo

# Call back the webhook step in Jenkins pipeline
if [ -n "${CALLBACK_URL}" ]; then
    CALLBACK_URL="http://jenkins/webhook-step/$(echo ${CALLBACK_URL} | sed 's/.*\///')"
    echo " curl -X POST -d ${HOSTNAME} ${CALLBACK_URL}"
    curl -s -X POST -d "${HOSTNAME}" "${CALLBACK_URL}"
else
    echo "no webhook set"
fi
