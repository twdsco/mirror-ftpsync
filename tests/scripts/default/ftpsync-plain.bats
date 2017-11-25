#!/usr/bin/env bats

load helper

setup() {
  setup_dirs
  coproc rsyncd { exec rsync --daemon --no-detach --config etc/default/rsyncd.conf --log-file $BATS_TEST_OWN_LOGDIR/rsyncd.log; }
}

teardown() {
  local pid=$rsyncd_PID
  if [[ $pid ]]; then
    kill -15 $pid || :
    wait $pid || :
  fi
}

@test "run ftpsync using plain transport" {
  run_ftpsync sync:archive:plain
  [[ $status -eq 0 ]]
}
