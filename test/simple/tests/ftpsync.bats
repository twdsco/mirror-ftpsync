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
}
