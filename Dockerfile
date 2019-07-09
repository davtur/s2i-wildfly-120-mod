# This image provides a base for building and running WildFly applications.
# It builds using maven and runs the resulting artifacts on WildFly 12.0.0 Final

FROM jboss/wildfly:12.0.0.Final

MAINTAINER Ben Parees <bparees@redhat.com>

EXPOSE 8080 9990 8081 9993

ENV WILDFLY_VERSION=12.0.0.Final \
    MAVEN_VERSION=3.5.4

LABEL io.k8s.description="Platform for building and running JEE applications on WildFly 12.0.0.Final" \
      io.k8s.display-name="WildFly 12.0.0.Final" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,wildfly,wildfly12" \
      io.openshift.s2i.assemble-input-files="/opt/jboss/wildfly/standalone/deployments;/opt/jboss/wildfly/standalone/configuration;/opt/jboss/wildfly/provided_modules" \
      io.openshift.s2i.destination="/opt/s2i/destination" \
      com.redhat.deployments-dir="/opt/jboss/wildfly/standalone/deployments" \
      maintainer="Dodgy Dave <david@manlyit.com.au"

# Install Maven, Wildfly
RUN INSTALL_PKGS="(curl -v https://www.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | \
    tar -zx -C /usr/local) && \
    ln -sf /usr/local/apache-maven-$MAVEN_VERSION/bin/mvn /usr/local/bin/mvn && \
    mkdir -p $HOME/.m2 && \
    mkdir -p /opt/s2i/destination"

# Add s2i wildfly customizations
ADD ./contrib/wfmodules/ /opt/jboss/wildfly/modules/
ADD ./contrib/wfbin/standalone.conf /opt/jboss/wildfly/bin/standalone.conf
ADD ./contrib/wfcfg/standalone.xml /opt/jboss/wildfly/standalone/configuration/standalone.xml
ADD ./contrib/settings.xml $HOME/.m2/

# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH
COPY ./s2i/bin/ $STI_SCRIPTS_PATH

RUN chown -R 1001:0 /opt/jboss/wildfly && chown -R 1001:0 $HOME && \
    chmod -R ug+rwX /opt/jboss/wildfly && \
    chmod -R g+rw /opt/s2i/destination

USER 1001

CMD $STI_SCRIPTS_PATH/usage
