#!/usr/bin/env bats

setup() {
  mkdir -p log
  coproc stunnel { exec stunnel etc/stunnel.conf 2>/dev/null; }
}

teardown() {
  local pid=$stunnel_PID
  if [[ $pid ]]; then
    kill -15 $pid || :
    wait $pid || :
  fi
}

@test "run ftpsync with ssl" {
  run bin/ftpsync -T test sync:archive:ssl
  [[ $status -eq 0 ]]
  ! [[ -f log/ftpsync-ssl.log ]]
  ! [[ -f log/rsync-ftpsync-ssl.log ]]
  ! [[ -f log/rsync-ftpsync-ssl.error ]]
  [[ -s log/ftpsync-ssl.log.0 ]]
  [[ -s log/rsync-ftpsync-ssl.log.0 ]]
  [[ -f log/rsync-ftpsync-ssl.error.0 ]]
}
