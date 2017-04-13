#!/bin/bash

unregister_runner() {
  echo "unregistering runner"
  TOKENS=`grep token ${CONFIG_FILE}  | awk '{print $3}' | cut -f2 -d\"`
  for token in $TOKENS; do
     echo $token
     gitlab-ci-multi-runner unregister -u ${GITLAB_CI_URL} -t $token
  done
}

trap unregister_runner HUP INT QUIT ABRT KILL ALRM TERM TSTP

# gitlab-ci-multi-runner data directory
DATA_DIR="/etc/gitlab-runner"
CONFIG_FILE=${CONFIG_FILE:-$DATA_DIR/config.toml}
# custom certificate authority path
CA_CERTIFICATES_PATH=${CA_CERTIFICATES_PATH:-$DATA_DIR/certs/ca.crt}
LOCAL_CA_PATH="/usr/local/share/ca-certificates/ca.crt"

update_ca() {
  echo "Updating CA certificates..."
  cp "${CA_CERTIFICATES_PATH}" "${LOCAL_CA_PATH}"
  update-ca-certificates --fresh >/dev/null
}

if [ -f "${CA_CERTIFICATES_PATH}" ]; then
  # update the ca if the custom ca is different than the current
  cmp --silent "${CA_CERTIFICATES_PATH}" "${LOCAL_CA_PATH}" || update_ca
fi

check_vars() {
 if [ -z ${GITLAB_CI_URL} ]; then echo "GITLAB_CI_URL not set"; exit 255; fi
 if [ -z ${GITLAB_REGISTRATION_TOKEN} ]; then echo "GITLAB_REGISTRATION_TOKEN not set"; exit 255; fi
 if [ -z "${GITLAB_RUNNER_TAGS}" ]; then echo "GITLAB_RUNNER_TAGS not set"; exit 255; fi
 if [ -z ${GITLAB_RUNNER_EXECUTOR} ]; then echo "GITLAB_RUNNER_EXECUTOR not set"; exit 255; fi
}


if [ ! -z ${GITLAB_RUNNER_AUTO_REGISTER} ]; then
  check_vars
  gitlab-ci-multi-runner register -n \
  -u ${GITLAB_CI_URL} \
  -r ${GITLAB_REGISTRATION_TOKEN} \
  --tag-list "${GITLAB_RUNNER_TAGS}" \
  --executor ${GITLAB_RUNNER_EXECUTOR} \
  ${GITLAB_RUNNER_EXTRA_ARGS}
fi

# launch gitlab-ci-multi-runner passing all arguments
exec gitlab-ci-multi-runner "$@" &
RD_PID=$!

echo $RD_PID
# Wait for either Rundeck to exit or a signal to be sent
while kill -0 $RD_PID >/dev/null 2>&1; do
   wait $RD_PID
   RET=$?
done
test $RET = 143 || echo "Rundeck exited with status $RET"
