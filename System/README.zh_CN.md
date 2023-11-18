# DogDayAndroid Buildbot

[English](./README.md) | 中文文档

---

这是一个基于 `LineageOS` 的个人修改版。

---

## 使用方法

```bash
chmod +x build.sh
bash build.sh
```

## 支持的补丁

### 自定义 Recovery

这个补丁由我个人实现，具体原理是通过修改编译流程来实现集成自定义的 `Recovery` 到刷机包中，如果您想了解具体的实现原理，请查看 [自定义 Recovery](https://easternday.top/Topic/Android/ROM/System/custom_recovery) 这个教程。

其中涉及到的工具有：

- [xiaoxindada/magiskboot_ndk_on_linux](https://github.com/xiaoxindada/magiskboot_ndk_on_linux)

整个替换流程参考了 `OrangeFox` 的打包脚本，应用此补丁后您需要导出如下环境变量：

```bash
export CUSTOM_MAGISKBOOT=<指向您使用的 MagiskBoot 工具的绝对路径>
export CUSTOM_TWRP=<指向您需要替换的 Recovery 镜像的绝对路径>
```

随后执行本脚本即可在最后内核打包的时候替换原有的 `boot.img`。

_值得注意的是，本补丁目前可能仅支持 `boot.img` 的替换修改，其他形式的可能需要您自行测验，如果您发现不行，请参照我的补丁给我提交 `Pull Request`。_

### 谷歌照片

通过将设备型号伪装为 `PixelXL` 来欺骗 `Google Photos` 从而实现无限图片云端存储。

这部分修改参考自:

- [crDroid](https://github.com/crdroidandroid/android_frameworks_base/blob/cc484e53adfe6be0bb5582502f49800951ed48b5/core/java/com/android/internal/util/crdroid/PixelPropsUtils.java#L249)

## 参考

- [ponces/treble_build_pe](https://github.com/ponces/treble_build_pe)
