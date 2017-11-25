#!/usr/bin/env bats

load helper

@test "run ftpsync" {
  run_ftpsync sync:archive:security
  [[ $status -eq 0 ]]

  ! [[ -f $BATS_TEST_OWN_LOGDIR/ftpsync-security.log ]]
  ! [[ -f $BATS_TEST_OWN_LOGDIR/rsync-ftpsync-security.log ]]
  ! [[ -f $BATS_TEST_OWN_LOGDIR/rsync-ftpsync-security.error ]]
  [[ -s $BATS_TEST_OWN_LOGDIR/ftpsync-security.log.0 ]]
  [[ -s $BATS_TEST_OWN_LOGDIR/rsync-ftpsync-security.log.0 ]]
  [[ -f $BATS_TEST_OWN_LOGDIR/rsync-ftpsync-security.error.0 ]]

  [[ -s $BATS_TEST_OWN_OUTDIR/project/trace/localhost ]]
  [[ -s $BATS_TEST_OWN_OUTDIR/project/trace/security.debian.org ]]
}

@test "run ftpsync-cron" {
  run_ftpsync_cron security
  [[ $status -eq 0 ]]

  [[ -s $BATS_TEST_OWN_LOGDIR/ftpsync-security.log.0 ]]
  [[ -s $BATS_TEST_OWN_LOGDIR/rsync-ftpsync-security.log.0 ]]
  ! [[ -f $BATS_TEST_OWN_LOGDIR/ftpsync-security.log.1 ]]
  ! [[ -f $BATS_TEST_OWN_LOGDIR/rsync-ftpsync-security.log.1 ]]

  run_ftpsync_cron security
  [[ $status -eq 0 ]]

  [[ -s $BATS_TEST_OWN_LOGDIR/ftpsync-security.log.0 ]]
  [[ -s $BATS_TEST_OWN_LOGDIR/rsync-ftpsync-security.log.0 ]]
  ! [[ -f $BATS_TEST_OWN_LOGDIR/ftpsync-security.log.1 ]]
  ! [[ -f $BATS_TEST_OWN_LOGDIR/rsync-ftpsync-security.log.1 ]]
}
