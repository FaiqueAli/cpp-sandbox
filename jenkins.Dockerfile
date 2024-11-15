FROM jenkins/jenkins:lts
USER root
RUN apt-get update
RUN curl -sSL https://get.docker.com/ | sh

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git

USER    jenkins
#command to run docker to start jenkins server
#docker run -p 8080:8080 -p 50000:50000 -d  -e DOCKER_HOST=tcp://host.docker.internal:2375 -v jenkins_home:/var/jenkins_home jenkins/docker:latest