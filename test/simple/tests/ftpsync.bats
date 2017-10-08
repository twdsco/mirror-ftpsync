#!/usr/bin/env bats

setup() {
  mkdir log
  rm -f log/rsyncd.pid
  rsync --daemon --config etc/rsyncd.conf
}

teardown() {
  kill -15 $(cat log/rsyncd.pid)
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
