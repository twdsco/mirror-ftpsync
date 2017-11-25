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

  [[ -s $outdir/project/trace/localhost ]]
  [[ -s $outdir/project/trace/master.example.com ]]
  grep 'Archive serial: 2017091804' $outdir/project/trace/localhost
  grep -v 'Trigger:' $outdir/project/trace/localhost
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

  [[ -s $outdir/project/trace/localhost ]]
  [[ -s $outdir/project/trace/master.example.com ]]
  grep 'Archive serial: 2017091804' $outdir/project/trace/localhost
  grep 'Trigger: ssh' $outdir/project/trace/localhost
}

@test "run ftpsync with non-existant archive" {
  run bin/ftpsync sync:archive:
  [[ $status -eq 78 ]]
}

@test "run ftpsync with non-existant archive, ssh comman" {
  SSH_ORIGINAL_COMMAND="sync:archive:" run bin/ftpsync
  [[ $status -eq 78 ]]
}

@test "run ftpsync with non-default trigger" {
  local testid=$(testid)
  local outdir=output/$testid

  run_ftpsync -T test sync:archive:default
  [[ $status -eq 0 ]]
  grep 'Trigger: test' $outdir/project/trace/localhost
}
