function setup_dirs() {
  export BATS_TEST_OWN_TESTID=security/$(basename $BATS_TEST_FILENAME)/$BATS_TEST_NUMBER
  BATS_TEST_OWN_LOGDIR=log/$BATS_TEST_OWN_TESTID
  BATS_TEST_OWN_OUTDIR=output/$BATS_TEST_OWN_TESTID
  rm -rf $BATS_TEST_OWN_LOGDIR $BATS_TEST_OWN_OUTDIR
  mkdir -p $BATS_TEST_OWN_LOGDIR $BATS_TEST_OWN_OUTDIR
}

function setup() {
  setup_dirs
}

function run_ftpsync() {
  run ./bin/ftpsync "$@"
}

function run_ftpsync_cron() {
  run ./bin/ftpsync-cron "$@"
}
