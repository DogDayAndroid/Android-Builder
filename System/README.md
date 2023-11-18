#DogDayAndroid Buildbot

[English](./README.md) | Chinese document

---

This is a personal modification based on `LineageOS`.

---

## Instructions

```bash
chmod +x build.sh
bash build.sh
```

## Supported patches

### Custom Recovery

This patch is implemented by me personally. The specific principle is to integrate the customized `Recovery` into the flash package by modifying the compilation process.

The tools involved are:

- [xiaoxindada/magiskboot_ndk_on_linux](https://github.com/xiaoxindada/magiskboot_ndk_on_linux)

The entire replacement process refers to the packaging script of `OrangeFox`. After applying this patch, you need to export the following environment variables:

```bash
export CUSTOM_MAGISKBOOT=<absolute path to the MagiskBoot tool you are using>
export CUSTOM_TWRP=<absolute path to the Recovery image you need to replace>
```

Then execute this script to replace the original `boot.img` when the final kernel is packaged.

_It is worth noting that this patch may currently only support the replacement and modification of `boot.img`. You may need to test other forms by yourself. If you find that it does not work, please refer to my patch and submit a `Pull Request` to me. _

### Google Photos

Spoof `Google Photos` to achieve unlimited image cloud storage by disguising the device model as `PixelXL`.

This part is modified from:

- [crDroid](https://github.com/crdroidandroid/android_frameworks_base/blob/cc484e53adfe6be0bb5582502f49800951ed48b5/core/java/com/android/internal/util/crdroid/PixelPropsUtils.java#L249)

## Reference

- [ponces/treble_build_pe](https://github.com/ponces/treble_build_pe)