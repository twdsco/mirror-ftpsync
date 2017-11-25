#!/usr/bin/env bats

load helper

@test "run ftpsync" {
  local testid=$(testid)
  local logdir=log/$testid
  local outdir=output/$testid

  run_ftpsync sync:archive:security
  [[ $status -eq 0 ]]

  ! [[ -f $logdir/ftpsync-security.log ]]
  ! [[ -f $logdir/rsync-ftpsync-security.log ]]
  ! [[ -f $logdir/rsync-ftpsync-security.error ]]
  [[ -s $logdir/ftpsync-security.log.0 ]]
  [[ -s $logdir/rsync-ftpsync-security.log.0 ]]
  [[ -f $logdir/rsync-ftpsync-security.error.0 ]]

  [[ -s $outdir/project/trace/localhost ]]
  [[ -s $outdir/project/trace/security.debian.org ]]
}

@test "run ftpsync-cron" {
  local testid=$(testid)
  local logdir=log/$testid
  local outdir=output/$testid

  run_ftpsync_cron security
  [[ $status -eq 0 ]]

  [[ -s $logdir/ftpsync-security.log.0 ]]
  [[ -s $logdir/rsync-ftpsync-security.log.0 ]]
  ! [[ -f $logdir/ftpsync-security.log.1 ]]
  ! [[ -f $logdir/rsync-ftpsync-security.log.1 ]]

  run_ftpsync_cron security
  [[ $status -eq 0 ]]

  [[ -s $logdir/ftpsync-security.log.0 ]]
  [[ -s $logdir/rsync-ftpsync-security.log.0 ]]
  ! [[ -f $logdir/ftpsync-security.log.1 ]]
  ! [[ -f $logdir/rsync-ftpsync-security.log.1 ]]
}
