#!/usr/bin/env bats

load helper

setup() {
  setup_dirs
  coproc stunnel { exec stunnel etc/default/stunnel.conf > $BATS_TEST_OWN_LOGDIR/stunnel.log 2>&1; }
}

teardown() {
  local pid=$stunnel_PID
  if [[ $pid ]]; then
    kill -15 $pid || :
    wait $pid || :
  fi
}

@test "run ftpsync using ssl transport" {
  run_ftpsync sync:archive:ssl
  [[ $status -eq 0 ]]
}
