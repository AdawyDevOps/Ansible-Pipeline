FROM  jenkins/jenkins:lts

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends ansible sudo \
    && rm -rf /var/lib/apt/lists/*

# Lab only: allow the jenkins user to run sudo without a password
RUN echo "jenkins ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/jenkins \
    && chmod 440 /etc/sudoers.d/jenkins

USER jenkins

