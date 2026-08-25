#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    openal \
    sdl3

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano libdecor-mini

echo "Building Yamagi Quake II..."
echo "---------------------------------------------------------------"
REPO="https://github.com/yquake2/yquake2"
if [ "${DEVEL_RELEASE-}" = 1 ]; then
    echo "Making nightly build of Yamagi Quake II..."
    echo "---------------------------------------------------------------"
    VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
    git clone "$REPO" ./yquake2
else
    echo "Making stable build of Yamagi Quake II..."
    echo "---------------------------------------------------------------"
    VERSION=$(git ls-remote --tags --refs --sort='v:refname' "$REPO" "refs/tags/QUAKE2_[0-9]*" | tail -n1 | cut -d/ -f3)
    git clone --branch "$VERSION" --single-branch "$REPO" ./yquake2
fi
echo "${VERSION#QUAKE2_}" | tr '_' '.' > ~/version

mkdir -p ./AppDir/bin
cd ./yquake2
make -j$(nproc) WITH_RPATH=no WITH_SYSTEMWIDE=yes
mv -v release/quake2 release/q2ded release/*.so release/baseq2 ../AppDir/bin
