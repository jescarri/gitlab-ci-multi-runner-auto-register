FROM gitlab/gitlab-runner:v1.11.2
MAINTAINER jesus.carrillo@ticketmaster.com
ADD entrypoint-auto.sh entrypoint-auto.sh
RUN chmod +x entrypoint-auto.sh
VOLUME ["/etc/gitlab-runner", "/home/gitlab-runner"]
ENTRYPOINT ["/entrypoint-auto.sh"]
CMD ["run", "--user=gitlab-runner", "--working-directory=/home/gitlab-runner"]
