
# Write kernel compilation configuration file

English | [中文文档](./README.zh_CN.md)

## Basic configuration file case

Each kernel compilation configuration file is a `Json` file ending with `.config.json`. The file is an array, and each `item` in the array is our kernel compilation configuration.

<details>
  <summary>Configuration template</summary>

```json
[
  {
    "kernelSource": {
      "name": "",
      "repo": "",
      "branch": "",
      "device": "",
      "defconfig": ""
    },
    "toolchains": [
      {
        "name": "",
        "repo": "",
        "branch": "",
        "binaryEnv": []
      },
      {
        "name": "",
        "url": "",
        "binaryEnv": []
      }
    ],
    "enableCcache": true,
    "params": {
      "ARCH": "",
      "CC": "",
      "externalCommands": {
        "CROSS_COMPILE": "",
        "CROSS_COMPILE_ARM32": "",
        "CROSS_COMPILE_COMPAT": "",
        "CLANG_TRIPLE": ""
      }
    },
    "AnyKernel3": {
      "use": true,
      "release": true,
      "custom": {
        "repo": "",
        "branch": ""
      }
    },
    "enableKernelSU": true,
    "enableLXC": false
  }
]
```

</details>

It is recommended to store different device kernels in different `Json` files, and each configuration can be different. This makes it easier to modify, view and classify the kernel configuration.

## Configuration parameter analysis

Each configuration template consists of the following parts:

| Field name | Description |
| -------------------------- | --------------------------------------------------------------------------------------------- |
| kernelSource | Information about the kernel source code, including name, repository address, branch, and device type. |
| toolchains | An array containing information about the toolchains that need to be used, including warehouse addresses, branches, and names. |
| enableCcache | A Boolean value indicating whether a compilation tool named `ccache` is used to speed up compilation. |
| params | An object containing information about build parameters, including architecture type, cross-compiler, compiler and other information. |
| AnyKernel3 | An object that contains information related to building the kernel flash package, including the `AnyKernel3` warehouse address, branch and other information used. |
| enableKernelSU | A Boolean value indicating whether the kernel patch named `KernelSU` is used. |
| enableLXC | A Boolean value indicating whether to enable `Docker` support. |

### Kernel source code configuration (kernelSource)

```json
"kernelSource": {
  "name": "", // The name you like has no effect. It is generally set to the device name + compilation tool chain version.
  "repo": "", // The warehouse address of the kernel source code
  "branch": "", // The branch name corresponding to the kernel source code repository
  "device": "", // Corresponding device number
  "defconfig": "" // The relative path of the corresponding defconfig file
}
```

The `name` part has no impact on the entire compilation process, so in theory you can set it as you like.

`repo`, `branch` are used to clone the kernel source code. We will clone all submodules under the source code by default to ensure the integrity of the kernel. The cloning code is as follows:

```bash
git clone --recursive --depth=1 -j $(nproc) --branch 
```

The content filled in `defconfig` is the relative path of your `defconfig` file relative to the `arch/arm64/configs` or `arch/arm/configs` folder. The reason for this is because some `defconfig` files may Exists in a subdirectory, we need to explicitly specify its relative path when `make`.

Here's a basic example:

```json
"kernelSource": {
  "name": "Mi6X",
  "repo": "https://github.com/Diva-Room/Miku_kernel_xiaomi_wayne",
  "branch": "TDA",
  "device": "wayne",
  "defconfig": "vendor/wayne_defconfig"
}
```

This kernel is the kernel source code of **Xiaomi 6X**. After opening its `Github` address on the web page, we see that its main branch is `TDA`, and its `defconfig` file is located in `/arch/arm64/configs/vendor /wayne_defconfig`, so set `defconfig` to `vendor/wayne_defconfig`.

### Toolchain configuration (toolchains)

The cross-compilation tool chain is an important tool when we compile the kernel, but the download forms of the compilation tool chain are various. You can use `git` to pull and download, or you can obtain it through downloading. Therefore, we have made adaptations for different acquisition methods. :

---

#### 1. Use `Git` to pull the compilation tool chain

```json
"toolchains": [
  {
    "name": "proton-clang",
    "repo": "https://github.com/kdrag0n/proton-clang",
    "branch": "master",
    "binaryEnv": ["./bin"]
  }
]
```

This part of the configuration is actually similar to the configuration of the kernel source code. We will also use the following command to pull the source code from the warehouse:

```bash
git clone --recursive --depth=1 -j $(nproc) --branch
```

However, a new `binaryEnv` has been added to this part, which is used to add global environment variable settings to our compilation tool chain, such as `./bin` here. After adding content, compilation will be added to the environment variables `bin` folder under the tool chain, which is of great benefit to our kernel compilation.

---

#### 2. Use `Wget` to download the compilation tool chain

In this way we can obtain the compilation tool chain compressed package in `.zip` | `.tar` | `.tar.gz` | `.rar` format.

```json
"toolchains": [
   {
     "name": "clang",
     "url": "https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/heads/master-kernel-build-2022/clang-r450784d.tar.gz" ,
     "binaryEnv": ["./bin"]
   },
   {
     "name": "gcc",
     "url": "https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/+archive/refs/tags/android-12.1.0_r27.tar. gz",
     "binaryEnv": ["bin"]
   }
]
```

`Action` will download and decompress them, and there will also be `binaryEnv` in this part. Its function is similar to the above function, so it will not be described again.

---

These two methods are not mutually exclusive. If we need both `Git` to pull and `Wget` to download the compilation toolchain, we can also mix them like the following configuration:

```json
"toolchains": [
   {
     "name": "clang",
     "repo": "https://gitlab.com/ThankYouMario/android_prebuilts_clang-standalone/",
     "branch": "11",
     "binaryEnv": ["bin"]
   },
   {
     "name": "gcc",
     "url": "https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/+archive/refs/tags/android-12.1.0_r27.tar. gz",
     "binaryEnv": ["bin"]
   }
]
```

### Compilation parameters (params)

#### basic configuration

Usually when we compile the kernel locally, we use a compilation command similar to the following:

```sh
make -j$(nproc --all) \
       O=out\
       ARCH=arm64 \
       CC=clang\
       CLANG_TRIPLE=aarch64-linux-gnu-\
       CROSS_COMPILE=aarch64-linux-gnu-\
       CROSS_COMPILE_ARM32=arm-linux-gnueabi-
```

Therefore, our compilation parameter configuration is also configured in a similar way:

```json
"params": {
   "ARCH": "arm64",
   "CC": "clang",
   "externalCommands": {
     "CLANG_TRIPLE": "aarch64-linux-gnu-",
     "CROSS_COMPILE": "proton-clang/bin/aarch64-linux-gnu-",
     "CROSS_COMPILE_ARM32": "proton-clang/bin/arm-linux-gnueabi-"
   }
}
```

The `-j` and `O=out` parts will be automatically configured by the compilation script, so there is no need to set them in the configuration. The `ARCH` and `CC` parts correspond to the above command part, and more other parameters correspond to the `externalCommand` part, such as the compilation parameter configuration of `markw`:

```json
"params": {
   "ARCH": "arm64",
   "CC": "clang",
   "externalCommands": {
     "CLANG_TRIPLE": "aarch64-linux-gnu-",
     "CROSS_COMPILE": "aarch64-linux-android-",
     "CROSS_COMPILE_ARM32": "arm-linux-androideabi-",
     "LD": "ld.lld",
     "AR": "llvm-ar",
     "NM": "llvm-nm",
     "OBJCOPY": "llvm-objcopy",
     "OBJDUMP": "llvm-objdump",
     "READELF": "llvm-readelf",
     "OBJSIZE": "llvm-size",
     "STRIP": "llvm-strip",
     "LDGOLD": "aarch64-linux-gnu-ld.gold",
     "LLVM_AR": "llvm-ar",
     "LLVM_DIS": "llvm-dis",
     "CONFIG_THINLTO": ""
   }
}
```

#### Turn on `ccache` to speed up compilation

During the kernel compilation process, repeated compilation will consume a lot of our time. `ccache` allows us to reuse some middleware caches from previous compilations to speed up compilation. For example, the compilation command in the previous section turns on `ccache` should be followed by:

```sh
make -j$(nproc --all) \
       O=out\
       ARCH=arm64 \
       CC="ccache clang" \
       CLANG_TRIPLE=aarch64-linux-gnu-\
       CROSS_COMPILE=aarch64-linux-gnu-\
       CROSS_COMPILE_ARM32=arm-linux-gnueabi-
```

In this way, we introduce a separate configuration parameter `enableCcache`. We only need to set `enableCcache` to `true` during configuration to implement the same command:

```json
"enableCcache": true,
"params": {
   "ARCH": "arm64",
   "CC": "clang",
   "externalCommands": {
     "CLANG_TRIPLE": "aarch64-linux-gnu-",
     "CROSS_COMPILE": "aarch64-linux-android-",
     "CROSS_COMPILE_ARM32": "arm-linux-androideabi-",
     "LD": "ld.lld",
     "AR": "llvm-ar",
     "NM": "llvm-nm",
     "OBJCOPY": "llvm-objcopy",
     "OBJDUMP": "llvm-objdump",
     "READELF": "llvm-readelf",
     "OBJSIZE": "llvm-size",
     "STRIP": "llvm-strip",
     "LDGOLD": "aarch64-linux-gnu-ld.gold",
     "LLVM_AR": "llvm-ar",
     "LLVM_DIS": "llvm-dis",
     "CONFIG_THINLTO": ""
   }
}
```

**Please note that `enableCcache` is an independent configuration, please make sure it exists. If you do not use it, please set it to `false` instead of deleting it directly.**

### Kernel flash package configuration (AnyKernel3)

Kernel packaging can be done through [AnyKernel3](https://github.com/osm0sis/AnyKernel3), [Android-Image-Kitchen](https://github.com/osm0sis/Android-Image-Kitchen), [MagiskBoot]( https://github.com/topjohnwu/Magisk/releases) and other tools to achieve this. Currently, this project only supports `AnyKernel3`, and its configuration is as follows:

```json
"AnyKernel3": {
   "use": true,
   "release": true,
   "custom": {
     "repo": "https://github.com/easterNday/AnyKernel3/",
     "branch": "thyme"
   }
}
```

In this configuration, I used the customized `AnyKernel3` for packaging. If you don’t want to `fork` a warehouse to implement it, you can choose to delete the `custom` field and use the original `AnyKernel3` to package your Kernel, the configuration after deletion is as follows:

```json
"AnyKernel3": {
   "use": true,
   "release": true
}
```

`use` in the configuration indicates whether you use `AnyKernel3` for packaging, `release` indicates whether you will release the packaged flash package, `release` only occurs when `AnyKernel3` is set to `true` takes effect, otherwise it defaults to `false`.

### Additional compilation parameter settings

#### KernelSU

Use `"enableKernelSU": true,` to control whether to enable `KernelSU`, set it to `false` to disable it.

#### LXC Docker

Use `"enableLXC": false` to control whether `Docker` support is enabled, set to `true` to enable it.

## Reference

- [DogDayAndroid/KSU_Thyme_BuildBot](https://github.com/DogDayAndroid/KSU_Thyme_BuildBot): The predecessor of this project
- [UtsavBalar1231/Drone-scripts](https://github.com/UtsavBalar1231/Drone-scripts): Refer to its compilation process
- [xiaoleGun/KernelSU_Action](https://github.com/xiaoleGun/KernelSU_Action): Refer to its original AnyKerne3 packaging part
