# FFmpeg Static Auto-Builds

Static Windows (x86_64) and Linux (x86_64) Builds of ffmpeg master and latest release branch.

Windows builds are targetting Windows 7 and newer, provided UCRT is installed.
The minimum supported version is Windows 10 22H2, no guarantees on anything older.

Linux builds are targetting RHEL/CentOS 8 (glibc-2.28 + linux-4.18) and anything more recent.

## Auto-Builds

Builds run daily at 12:00 UTC (or GitHubs idea of that time) and are automatically released on success.

**Auto-Builds run ONLY for win64 and linux(arm)64. There are no win32/x86 auto-builds, though you can produce win32 builds yourself following the instructions below.**

### Release Retention Policy

- The last build of each month is kept for two years.
- The last 14 daily builds are kept.
- The special "latest" build floats and provides consistent URLs always pointing to the latest build.

## Package List

For a list of included dependencies check the scripts.d directory.
Every file corresponds to its respective package.

## How to make a build

### Prerequisites

* bash
* docker

### Build Image

* `./makeimage.sh target variant [addin [addin] [addin] ...]`

### Build FFmpeg

* `./build.sh target variant [addin [addin] [addin] ...]`

On success, the resulting zip file will be in the `artifacts` subdir.

### Targets, Variants and Addins

Available targets:
* `win64` (x86_64 Windows)
* `linux64` (x86_64 Linux, glibc>=2.28, linux>=4.18)
* `linuxarm64` (arm64 (aarch64) Linux, glibc>=2.28, linux>=4.18)

The linuxarm64 target will not build some dependencies due to lack of arm64 (aarch64) architecture support or cross-compiling restrictions.

* `davs2` and `xavs2`: aarch64 support is broken.
* `libmfx` and `libva`: Library for Intel QSV, so there is no aarch64 support.

Available variants:
* `gpl` Includes all dependencies, even those that require full GPL instead of just LGPL.
* `lgpl` Lacking libraries that are GPL-only. Most prominently libx264 and libx265.
* `nonfree` Includes fdk-aac in addition to all the dependencies of the gpl variant.
* `nonfree-shared` Same again, but with the nonfree set of dependencies.

All of those can be optionally combined with any combination of addins:
* `6.1`/`7.0`/`7.1` to build from the respective release branch instead of master.
* `debug` to not strip debug symbols from the binaries. This increases the output size by about 250MB.
* `lto` build all dependencies and ffmpeg with -flto=auto (HIGHLY EXPERIMENTAL, broken for Windows, sometimes works for Linux)


## Patches Applied
These patches have been applied to the builds:

### 1. Decoding non-standard HEVC in FLV containers

HEVC inside FLV has been [standardized](https://github.com/veovera/enhanced-rtmp/blob/8c51d437e20a9199d92f24d9950b1216e07f065f/enhanced-rtmp.pdf) by [@Veovera](https://github.com/veovera), implemented by [@T-bagwell](https://github.com/T-bagwell) and merged to FFmpeg master in [aa83654](https://github.com/FFmpeg/FFmpeg/commit/aa83654d940e7599ee641fc5d0fcd10e7decf277) and [ac5cc66](https://github.com/FFmpeg/FFmpeg/commit/ac5cc66f9e4408c45c303f6bf482ff04d7cb355e).

Chinese sites seem to continue using an old non-standard way to deliver HEVC in FLV containers. These builds of FFmpeg support the decoding of such files.

Releases older than 6.1 also supported the encoding of such non-standard files. The implementation was assembled from patches by [@xiaoxial](https://github.com/VCDP/CDN/blob/master/FFmpeg_patches/0001-Add-SVT-HEVC-FLV-support-on-FFmpeg.patch), [@runner365](https://github.com/runner365/ffmpeg_rtmp_h265/blob/5.1/flvenc.c), and [Matthieu Patou](https://patchwork.ffmpeg.org/project/ffmpeg/patch/20210701141528.776-1-jamrial@gmail.com/).
See [this comment](https://github.com/yt-dlp/yt-dlp/pull/5823#issuecomment-1366868753) for details.

Fixes [yt-dlp#5874](https://github.com/yt-dlp/yt-dlp/issues/5874), [FFmpeg#6389](https://trac.ffmpeg.org/ticket/6389).

## Credits

* [@BtbN](https://github.com/BtbN) for the [original workflow](https://github.com/BtbN/FFmpeg-Builds)
* [@nihil-admirari](https://github.com/nihil-admirari) for creating and maintaining this repo
* [@yt-dlp](https://github.com/yt-dlp) for the [modified workflow](https://github.com/yt-dlp/FFmpeg-Builds)

---

PS: The commits are unsigned because of the periodic [automatic rebase](https://github.com/yt-dlp/FFmpeg-Builds/actions/workflows/rebase-on-upstream.yml)
