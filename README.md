gitlab-ci-multirunner-auto-register
==================================

Usage:

To auto register a worker and run the runner:

```
    docker docker run -e GITLAB_CI_URL=https://gitlab.com/ci/ \
    -e GITLAB_REGISTRATION_TOKEN=FOOBAR_TOKEN \
    -e GITLAB_RUNNER_TAGS="us-east-1-dev, kubernetes, foo, bar" \
    -e GITLAB_RUNNER_EXECUTOR=kubernetes \
    -e GITLAB_RUNNER_AUTO_REGISTER=true \
    -e GITLAB_RUNNER_EXTRA_ARGS='--kubernetes-service-cpu-limit=2m --kubernetes-helper-image=foobar ...' \
    jescarri/gitlab-ci-multi-runner-auto-register run
```
