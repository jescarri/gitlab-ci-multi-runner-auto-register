docker run -e GITLAB_CI_URL=https://gitlab.identitylabs.mx/ci/ \
-e GITLAB_REGISTRATION_TOKEN=zgGJQqGs-ghcJ3ou122e \
-e GITLAB_RUNNER_TAGS="us-east-1-dev, kubernetes, foo, bar" \
-e GITLAB_RUNNER_EXECUTOR=kubernetes \
-e GITLAB_RUNNER_AUTO_REGISTER=true runner run
