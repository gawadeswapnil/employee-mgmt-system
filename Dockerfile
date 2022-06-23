FROM tomcat:9.0
MAINTAINER "Swapnil Gawade"
COPY ./target/*.war /usr/local/tomcat/webapps/employee-management.war
