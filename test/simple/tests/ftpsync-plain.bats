#!/usr/bin/env bats

setup() {
  mkdir -p log
  coproc rsyncd { exec rsync --daemon --no-detach --config etc/rsyncd.conf; }
}

teardown() {
  kill -15 $rsyncd_PID
}

@test "run ftpsync" {
  run bin/ftpsync -T test sync:archive:plain
  [[ $status -eq 0 ]]
  ! [[ -f log/ftpsync-plain.log ]]
  ! [[ -f log/rsync-ftpsync-plain.log ]]
  ! [[ -f log/rsync-ftpsync-plain.error ]]
}

@test "run ftpsync, ssh command" {
  SSH_ORIGINAL_COMMAND="sync:archive:plain" run bin/ftpsync
  [[ $status -eq 0 ]]
}
