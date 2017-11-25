#!/usr/bin/env bats

load helper

@test "run ftpsync" {
  run_ftpsync sync:archive:default
  [[ $status -eq 0 ]]

  ! [[ -f $BATS_TEST_OWN_LOGDIR/ftpsync-default.log ]]
  ! [[ -f $BATS_TEST_OWN_LOGDIR/rsync-ftpsync-default.log ]]
  ! [[ -f $BATS_TEST_OWN_LOGDIR/rsync-ftpsync-default.error ]]

  [[ -s $BATS_TEST_OWN_OUTDIR/project/trace/localhost ]]
  [[ -s $BATS_TEST_OWN_OUTDIR/project/trace/master.example.com ]]
  grep 'Archive serial: 2017091804' $BATS_TEST_OWN_OUTDIR/project/trace/localhost
  grep -v 'Trigger:' $BATS_TEST_OWN_OUTDIR/project/trace/localhost
}

@test "run ftpsync, ssh command" {
  SSH_ORIGINAL_COMMAND="sync:archive:default" run_ftpsync
  [[ $status -eq 0 ]]

  ! [[ -f $BATS_TEST_OWN_LOGDIR/ftpsync-default.log ]]
  ! [[ -f $BATS_TEST_OWN_LOGDIR/rsync-ftpsync-default.log ]]
  ! [[ -f $BATS_TEST_OWN_LOGDIR/rsync-ftpsync-default.error ]]

  [[ -s $BATS_TEST_OWN_OUTDIR/project/trace/localhost ]]
  [[ -s $BATS_TEST_OWN_OUTDIR/project/trace/master.example.com ]]
  grep 'Archive serial: 2017091804' $BATS_TEST_OWN_OUTDIR/project/trace/localhost
  grep 'Trigger: ssh' $BATS_TEST_OWN_OUTDIR/project/trace/localhost
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
  run_ftpsync -T test sync:archive:default
  [[ $status -eq 0 ]]
  grep 'Trigger: test' $BATS_TEST_OWN_OUTDIR/project/trace/localhost
}
