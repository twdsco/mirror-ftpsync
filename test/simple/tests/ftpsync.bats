#!/usr/bin/env bats

load helper

@test "run ftpsync" {
  local testid=$(testid)
  local logdir=log/$testid
  local outdir=output/$testid

  run_ftpsync sync:archive:default
  [[ $status -eq 0 ]]
  ! [[ -f $logdir/ftpsync-default.log ]]
  ! [[ -f $logdir/rsync-ftpsync-default.log ]]
  ! [[ -f $logdir/rsync-ftpsync-default.error ]]
}

@test "run ftpsync, ssh command" {
  local testid=$(testid)
  local logdir=log/$testid
  local outdir=output/$testid

  SSH_ORIGINAL_COMMAND="sync:archive:default" run_ftpsync
  [[ $status -eq 0 ]]
  ! [[ -f $logdir/ftpsync-default.log ]]
  ! [[ -f $logdir/rsync-ftpsync-default.log ]]
  ! [[ -f $logdir/rsync-ftpsync-default.error ]]
}

@test "run ftpsync with non-existant archive" {
  run bin/ftpsync sync:archive:
  [[ $status -eq 78 ]]
}

@test "run ftpsync with non-existant archive, ssh comman" {
  SSH_ORIGINAL_COMMAND="sync:archive:" run bin/ftpsync
  [[ $status -eq 78 ]]
}
