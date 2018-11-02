# Generated by IBM TransformationAdvisor
# Fri Nov 02 17:57:02 EDT 2018


#IMAGE: Get the base image for Liberty
FROM websphere-liberty:webProfile7

#BINARIES: Add in all necessary application binaries
COPY ./server.xml /config
COPY ./binary-modresorts-1.0.war /config/dropins/modresorts-1.0.war
RUN ls -la /config/dropins/
RUN mkdir /opt/ibm/wlp/usr/shared/resources/db2
COPY ./db2driver-db2jcc.jar /opt/ibm/wlp/usr/shared/resources/db2/db2jcc.jar
RUN ls -la /opt/ibm/wlp/usr/shared/resources/db2/



#FEATURES: Install any features that are required
RUN apt-get update && apt-get dist-upgrade -y \
#&& rm -rf /var/lib/apt/lists/*
RUN /opt/ibm/wlp/bin/installUtility install  --acceptLicense \
	jsp-2.3 \
	ejbLite-3.2 \
	jaxb-2.2 \
	servlet-3.1 \
	jsf-2.2 \
	mdb-3.2 \
	jndi-1.0 \
	jms-2.0 \
	jdbc-4.1 \
	jpa-2.1 \
	wasJmsServer-1.0 \
	wasJmsClient-2.0; exit 0


# Upgrade to production license if URL to JAR provided
ARG LICENSE_JAR_URL
RUN \
   if [ $LICENSE_JAR_URL ]; then \
     wget $LICENSE_JAR_URL -O /tmp/license.jar \
     && java -jar /tmp/license.jar -acceptLicense /opt/ibm \
     && rm /tmp/license.jar; \
   fi
