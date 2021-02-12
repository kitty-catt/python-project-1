FROM fabric8/java-centos-openjdk8-jdk:latest
MAINTAINER kitty-catt

ENV JMETER_BASE="/opt/jmeter" \
    VERSION="5.3" 

# Do not optimize these layers as the variables are not initialized when all is in a single layer.
ENV JMETER_HOME="$JMETER_BASE/apache-jmeter-$VERSION" 
ENV PATH="$JMETER_HOME/bin:$PATH"

#RUN env

USER root

RUN groupadd -r jmeter -f -g 1001 && \
    useradd -u 1001 -r -g jmeter -m -d $JMETER_BASE -s /usr/sbin/nologin -c "jmeter container user" jmeter

# Create jmeter directory with tests and results folder and install JMeter
RUN mkdir -pv $JMETER_BASE/{tests,results} &&\
 curl -SL https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-$VERSION.tgz  -o apache-jmeter-$VERSION.tgz &&\
 tar -C $JMETER_BASE -xvf apache-jmeter-$VERSION.tgz  &&\
 rm -rf apache-jmeter-$VERSION.tgz  

#VOLUME ["$JMETER_BASE/tests", "$JMETER_BASE/results"]
VOLUME ["$JMETER_BASE/tests"]

# Additional jars (for example jdbc or jms drivers) can be copied into $JMETER_HOME/lib
COPY lib/* $JMETER_HOME/lib/

# Copy custom user.properties file for reports dashboard to be generated
# COPY user.properties $JMETER_HOME/bin/user.properties

# Set working directory
WORKDIR $JMETER_BASE

COPY scripts/run.sh $JMETER_BASE/run.sh

RUN chmod +x -R $JMETER_HOME

RUN chown -R 1001:0 $JMETER_BASE && \
    chgrp -R 0 $JMETER_BASE && \
    chmod -R g=u $JMETER_BASE

#RUN yum install -y sleep

#1001 is the container user
USER 1001

ENTRYPOINT $JMETER_BASE/run.sh
#ENTRYPOINT ["sleep", "120"]