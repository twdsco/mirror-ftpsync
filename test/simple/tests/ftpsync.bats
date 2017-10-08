#!/usr/bin/env bats

setup() {
  mkdir -p log
  coproc rsyncd { exec rsync --daemon --no-detach --config etc/rsyncd.conf; }
}

teardown() {
  kill -15 $rsyncd_PID
}

@test "run ftpsync" {
  run bin/ftpsync -T test
  [[ $status -eq 0 ]]
  ! [[ -f log/ftpsync.log ]]
  ! [[ -f log/rsync-ftpsync.log ]]
  ! [[ -f log/rsync-ftpsync.error ]]
  [[ -s log/ftpsync.log.0 ]]
  [[ -s log/rsync-ftpsync.log.0 ]]
  [[ -f log/rsync-ftpsync.error.0 ]]
}
