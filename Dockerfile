FROM tomcat:9.0
MAINTAINER "Swapnil"
COPY ./target/*.war /usr/local/tomcat/webapps/employee-management.war
