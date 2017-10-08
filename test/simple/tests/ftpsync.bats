#!/usr/bin/env bats

setup() {
  ln -s $(pwd)/rsyncd /rsyncd
  rm -f /rsyncd.pid
  rsync --daemon --log-file $(pwd)/log/rsyncd.log --config $(pwd)/etc/rsyncd.conf
}

teardown() {
  kill -15 $(cat /rsyncd.pid)
}

@test "run ftpsync" {
  run bin/ftpsync -T test
  [[ $status -eq 0 ]]
}
