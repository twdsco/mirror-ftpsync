#!/usr/bin/env bats

load helper

setup() {
  local logdir=log/$(testid)
  mkdir -p $logdir
  coproc rsyncd { exec rsync --daemon --no-detach --config etc/rsyncd.conf --log-file $logdir/rsyncd.log; }
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
