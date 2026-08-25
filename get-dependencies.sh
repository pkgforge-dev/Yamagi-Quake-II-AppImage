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

# Comment this out if you need an AUR package
#make-aur-package PACKAGENAME

# If the application needs to be manually built that has to be done down here

# if you also have to make nightly releases check for DEVEL_RELEASE = 1
#
#if [ "${DEVEL_RELEASE-}" = 1 ]; then
#    package=yamagi-quake2-git
#else
#    package=yamagi-quake2
#fi
#make-aur-package "$package"
#pacman -Q "$package" | awk '{print $2; exit}' > ~/version

#mkdir -p ./AppDir/bin
#mv -v /usr/lib/yamagi-quake2/* ./AppDir/bin

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
    VERSION=$(git ls-remote --tags --refs --sort='v:refname' "$REPO" "refs/tags/ra*" | tail -n1 | cut -d/ -f3)
    git clone --branch "$VERSION" --single-branch "$REPO" ./yquake2
fi
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
cd ./yquake2
make -j$(nproc) WITH_RPATH=no WITH_SYSTEMWIDE=yes
mv -v release/quake2 release/q2ded release/*.so release/baseq2 ../AppDir/bin
