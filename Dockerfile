FROM alpine:latest
MAINTAINER jesus.carrillo@ticketmaster.com
ADD https://github.com/Yelp/dumb-init/releases/download/v1.0.2/dumb-init_1.0.2_amd64 /usr/bin/dumb-init
RUN chmod +x /usr/bin/dumb-init
RUN apk add --update \
		bash \
		ca-certificates \
		git \
		openssl \
		wget
ADD gitlab-ci-multi-runner-linux-amd64 /usr/bin/gitlab-ci-multi-runner
RUN chmod +x /usr/bin/gitlab-ci-multi-runner && \
	ln -s /usr/bin/gitlab-ci-multi-runner /usr/bin/gitlab-runner && \
	wget -q https://github.com/docker/machine/releases/download/v0.10.0/docker-machine-Linux-x86_64 -O /usr/bin/docker-machine && \
	chmod +x /usr/bin/docker-machine && \
	mkdir -p /etc/gitlab-runner/certs && \
	chmod -R 700 /etc/gitlab-runner
COPY entrypoint /
RUN chmod +x /entrypoint
RUN chmod +x /usr/bin/gitlab-ci-multi-runner
VOLUME ["/etc/gitlab-runner", "/home/gitlab-runner"]
ENTRYPOINT ["/usr/bin/dumb-init", "/entrypoint"]
CMD ["run", "--user=gitlab-runner", "--working-directory=/home/gitlab-runner"]
