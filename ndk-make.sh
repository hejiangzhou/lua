#!/bin/bash -e
if [ -z "${NDK_ARCH}" ]; then
    NDK_ARCH=arm
fi
if [ -z "${ANDROID_PLATFORM}" ]; then
    ANDROID_PLATFORM=android-16
fi
if [ -z "${NDK_ROOT}" ]; then
    echo "NDK_ROOT not set!"
    exit 1
fi
tool_dir=$(mktemp -d /tmp/ndk-build-XXXXXX)
${NDK_ROOT}/build/tools/make-standalone-toolchain.sh \
    --platform=${ANDROID_PLATFORM} --arch=${NDK_ARCH} --install_dir=${tool_dir}
export PATH=${tool_dir}/${NDK_ARCH}-linux-androideabi/bin:$PATH
if make ndk "$@"; then
    mkdir -p out/${NDK_ARCH}
    cp src/liblua.a out/${NDK_ARCH}
    RET=0
else
    RET=1
fi
rm -rf ${tool_dir}
exit ${RET}
