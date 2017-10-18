#!/usr/bin/env bats

load helper

setup() {
  local logdir=log/$(testid)
  mkdir -p $logdir
  coproc stunnel { exec stunnel etc/stunnel.conf >$logdir/stunnel.log 2>&1; }
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
