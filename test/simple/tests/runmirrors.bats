#!/usr/bin/env bats

setup() {
  echo "" > ~/key
}

@test "run runmirrors" {
  run bin/runmirrors
  [[ $status -eq 0 ]]
  [[ -f log/runmirrors.log ]]
}
