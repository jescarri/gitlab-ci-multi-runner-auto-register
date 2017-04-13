FROM gitlab/gitlab-runner:v1.11.2
MAINTAINER jesus.carrillo@ticketmaster.com
ADD entrypoint /entrypoint 
RUN chmod +x entrypoint
VOLUME ["/etc/gitlab-runner", "/home/gitlab-runner"]
ENTRYPOINT ["/entrypoint"]
CMD ["run", "--user=gitlab-runner", "--working-directory=/home/gitlab-runner"]
