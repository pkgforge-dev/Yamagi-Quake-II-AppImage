#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    libdecor \
    openal   \
    sdl3

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package PACKAGENAME

# If the application needs to be manually built that has to be done down here

# if you also have to make nightly releases check for DEVEL_RELEASE = 1
#
if [ "${DEVEL_RELEASE-}" = 1 ]; then
    package=yamagi-quake2-git
else
    package=yamagi-quake2
fi
make-aur-package "$package"
pacman -Q "$package" | awk '{print $2; exit}' > ~/version

mkdir -p ./AppDir/bin
mv -v /usr/lib/yamagi-quake2/* ./AppDir/bin
