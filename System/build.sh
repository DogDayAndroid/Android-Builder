#!/bin/bash

echo
echo "--------------------------------------"
echo "        DogDayAndroid Buildbot        "
echo "                by                    "
echo "             easterNday               "
echo "--------------------------------------"
echo

# set -xe
set -e

# 获取脚本所在路径
ROOT=$(cd $(dirname $0);pwd)

# BL=$PWD/treble_build_pe
OUTPUTS=$ROOT/builds

# 初始化仓库
initRepos() {
    if [ ! -d $ROOT/LineageOS ]; then
        mkdir -p $ROOT/LineageOS
        cd $ROOT/LineageOS
        echo "--> Initializing LineageOS Repo"
        repo init -u https://github.com/LineageOS/android -b lineage-20.0
        echo
    fi
}

# 仓库应用DogDay补丁
applyManifestsPatches() {
    if [ -d $ROOT/LineageOS ]; then
        cd $ROOT/LineageOS/.repo/manifests
        echo "--> Discard Manifests Changes"
        git fetch origin
        git reset --hard origin/lineage-20.0
        echo

        echo "--> Patching Repo Manifests"
        git am $ROOT/Patches/LineageOS/manifests/*.patch
        echo
    fi
}

# 同步仓库内容
syncRepos() {
    if [ -d $ROOT/LineageOS ]; then
        cd $ROOT/LineageOS
        echo "--> Syncing repos"
        repo sync -c --force-sync --no-clone-bundle --no-tags -j16
        echo
    fi
}

# applyPatches() {
#     echo "--> Applying prerequisite patches"
#     bash $BL/apply-patches.sh $BL prerequisite
#     echo

#     echo "--> Applying TrebleDroid patches"
#     bash $BL/apply-patches.sh $BL trebledroid
#     echo

#     echo "--> Applying personal patches"
#     bash $BL/apply-patches.sh $BL personal
#     echo

#     echo "--> Generating makefiles"
#     cd device/phh/treble
#     cp $BL/pe.mk .
#     bash generate.sh pe
#     cd ../../..
#     echo
# }

# 应用补丁
applyPatches() {
    cd $ROOT/Patches/LineageOS

    echo "--> Applying personal patches"
    # Device camouflage patch
    python $ROOT/Patches/apply.py $ROOT/LineageOS $ROOT/Patches/LineageOS/mask
    # Custom recovery patch
    python $ROOT/Patches/apply.py $ROOT/LineageOS $ROOT/Patches/LineageOS/custom_recovery
    echo
}

# 设置环境
setupEnv() {
    echo "--> Setting up build environment"
    cd $ROOT/LineageOS
    source build/envsetup.sh
    # mkdir -p $OUTPUTS
    echo
}

# 开始编译
build() {
    echo "--> Building DogDayAndroid"
    export RELEASE_TYPE=RELEASE
    lunch lineage_thyme-userdebug
    croot
    # mka clobber
    mka bacon -j20 2>&1 | tee build.log
    # mv $OUT/system.img $BD/system-treble_arm64_bvN-slim.img
    echo
}

# buildVariant() {
#     echo "--> Building treble_arm64_bvN"
#     lunch treble_arm64_bvN-userdebug
#     make -j$(nproc --all) installclean
#     make -j$(nproc --all) systemimage
#     mv $OUT/system.img $BD/system-treble_arm64_bvN.img
#     echo
# }

# generateOta() {
#     echo "--> Generating OTA file"
#     version="$(date +v%Y.%m.%d)"
#     timestamp="$START"
#     json="{\"version\": \"$version\",\"date\": \"$timestamp\",\"variants\": ["
#     find $BD/ -name "PixelExperience_*" | sort | {
#         while read file; do
#             filename="$(basename $file)"
#             if [[ $filename == *"vndklite"* ]]; then
#                 name="treble_arm64_bvN-vndklite"
#             elif [[ $filename == *"slim"* ]]; then
#                 name="treble_arm64_bvN-slim"
#             else
#                 name="treble_arm64_bvN"
#             fi
#             size=$(wc -c $file | awk '{print $1}')
#             url="https://github.com/ponces/treble_build_pe/releases/download/$version/$filename"
#             json="${json} {\"name\": \"$name\",\"size\": \"$size\",\"url\": \"$url\"},"
#         done
#         json="${json%?}]}"
#         echo "$json" | jq . > $BL/ota.json
#     }
#     echo
# }

START=$(date +%s)

initRepos
applyManifestsPatches
syncRepos
applyPatches
setupEnv
build

# generatePackages
# generateOta

END=$(date +%s)
ELAPSEDM=$(($(($END-$START))/60))
ELAPSEDS=$(($(($END-$START))-$ELAPSEDM*60))

echo "--> Buildbot completed in $ELAPSEDM minutes and $ELAPSEDS seconds"
echo