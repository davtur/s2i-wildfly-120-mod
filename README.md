# s2i-wildfly-120-mod
openshift/s2i-wildfly fork modified 12.0.Final to load system modules to get eclipselink to load

Adding a New Builder Image
Build the builder image in the OpenShift namespace and store the image in the
OpenShift Registry:
$ oc new-build https://github.com/davtur/s2i-wildfly-120-mod.git -n
openshift
