#!/bin/bash

LIBXV_REPO="https://gitlab.freedesktop.org/xorg/lib/libxv.git"
LIBXV_COMMIT="03a6f599d060591a9a7cd8558bd2143a1c7c70d7"

ffbuild_enabled() {
    [[ $TARGET != linux* ]] && return -1
    [[ $ADDINS_STR == *4.4* ]] && return -1
    return 0
}

ffbuild_dockerbuild() {
    git-mini-clone "$LIBXV_REPO" "$LIBXV_COMMIT" libxv
    cd libxv

    autoreconf -i

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --disable-shared
        --enable-static
        --with-pic
        --without-lint
    )

    if [[ $TARGET == linux* ]]; then
        myconf+=(
            --host="$FFBUILD_TOOLCHAIN"
        )
    else
        echo "Unknown target"
        return -1
    fi

    ./configure "${myconf[@]}"
    make -j$(nproc)
    make install
}

ffbuild_configure() {
    # Needs a patch to FFmpeg to fix static linking first
    echo #--enable-xlib
}

ffbuild_unconfigure() {
    echo --disable-xlib
}