FROM tomcat:latest
RUN cp -R /usr/local/tomcat/webapps.dist/* /usr/local/tomcat/webapps
WORKDIR /opt/docker
RUN pwd
COPY *.war /usr/local/tomcat/webapps
EXPOSE 8080
CMD ["catalina.sh", "run"]

