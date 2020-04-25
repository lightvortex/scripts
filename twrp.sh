echo //disable ccache//
#still using android 9 as base causes errors with ccache
export CCACHE_DISABLE=1
echo //build env setup//
virtualenv2 venv
source venv/bin/activate
. build/env*
export ALLOW_MISSING_DEPENDENCIES=true
export LC_ALL="C"
