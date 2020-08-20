echo //enable ccache//
export USE_CCACHE=1
echo //build env setup//
virtualenv2 venv
source venv/bin/activate
. build/env*
echo //syncing//
rm -rf packages/apps/Settings/
rm -rf frameworks/base/
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags
echo //building gapps//
export WITH_GAPPS=true && export TARGET_GAPPS_ARCH=arm64
#export WITH_GAPPS=false
echo //adding faceunlock //
bash external/motorola/faceunlock/regenerate/r*.sh
breakfast nx531j
mka api-stubs-docs && mka hiddenapi-lists-docs && mka system-api-stubs-docs && mka test-api-stubs-docs && 
brunch nx531j
