FROM gitlab/gitlab-runner:v1.11.2
MAINTAINER jesus.carrillo@ticketmaster.com
ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 /usr/bin/dumb-init
RUN chmod +x /usr/bin/dumb-init 
ADD entrypoint-auto.sh entrypoint-auto.sh
RUN chmod +x entrypoint-auto.sh
VOLUME ["/etc/gitlab-runner", "/home/gitlab-runner"]
ENTRYPOINT ["/entrypoint-auto.sh"]
CMD ["run", "--user=gitlab-runner", "--working-directory=/home/gitlab-runner"]
