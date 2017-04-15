FROM alpine:latest
MAINTAINER jesus.carrillo@ticketmaster.com
ADD gitlab-ci-multi-runner-linux-amd64 /bin/gitlab-ci-multi-runner
RUN chmod +x /bin/gitlab-ci-multi-runner
VOLUME ["/etc/gitlab-runner", "/home/gitlab-runner"]
