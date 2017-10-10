#!/usr/bin/env bats

@test "run ftpsync with non-existant archive" {
  run bin/ftpsync sync:archive:
  [[ $status -eq 78 ]]
}

@test "run ftpsync with non-existant archive, ssh comman" {
  SSH_ORIGINAL_COMMAND="sync:archive:" run bin/ftpsync
  [[ $status -eq 78 ]]
}
