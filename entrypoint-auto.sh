#!/bin/bash

unregister_runner() {
  echo "unregistering runner"
  TOKENS=`grep token ${CONFIG_FILE}  | awk '{print $3}' | cut -f2 -d\"`
  for token in $TOKENS; do
     echo $token
     gitlab-ci-multi-runner unregister -u ${GITLAB_URL} -t $token
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
 if [ -z ${GITLAB_URL} ]; then echo "GITLAB_URL not set"; exit 255; fi
 if [ -z ${REGISTRATION_TOKEN} ]; then echo "REGISTRATION_TOKEN not set"; exit 255; fi
 if [ -z "${RUNNER_TAGS}" ]; then echo "RUNNER_TAGS not set"; exit 255; fi
 if [ -z "${RUNNER_NAME}" ]; then echo "GITLAB_RUNNER_NAME not set"; exit 255; fi
}

# launch gitlab-ci-multi-runner passing all arguments
CI_SERVER_TOKEN=`grep token ${CONFIG_FILE}  | awk '{print $3}' | cut -f2 -d\"`
exec gitlab-ci-multi-runner "$@" &
GR_PID=$!
# Wait for runner to die or get a signal
while kill -0 $GR_PID >/dev/null 2>&1; do
   wait $GR_PID
   RET=$?
done
test $RET = 143 || echo "gitlab-multi-runner exited with status $RET"
