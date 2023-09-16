<div align = center>

<img src="../.assets/DogDayAndroid.png" width="200" height="175" alt="banner">

<h1>How to modify your own config</h1>

English | [中文](./README_cn.md)

![License](https://img.shields.io/static/v1?label=License&message=BY-NC-SA&logo=creativecommons&color=green)
![Language](https://img.shields.io/github/languages/top/DogDayAndroid/Android-Kernel-Builder)
![Issues](https://img.shields.io/github/issues/DogDayAndroid/Android-Kernel-Builder)
![Pull Requests](https://img.shields.io/github/issues-pr/DogDayAndroid/Android-Kernel-Builder)
<br>

This section contains basic configuration file configuration tutorials, as well as the website under development.
<br>

---

</div>

## Example configuration file
  
```json
[
  {
    "kernelSource": {
      "name": "DogDay-KernelSU-Proton-release",
      "repo": "https://codeberg.org/DogDayAndroid/android_kernel_xiaomi_thyme",
      "branch": "lineage-20.0",
      "device": "thyme",
      "defconfig": "thyme_defconfig"
    },
    "withKernelSU": true,
    "toolchains": [
      {
        "repo": "https://github.com/kdrag0n/proton-clang",
        "branch": "master",
        "name": "proton-clang",
        "binPath": ["bin"]
      }
    ],
    "ccache":false,
    "params": {
      "ARCH": "arm64",
      "CC": "proton-clang/bin/clang",
      "externalCommand": {
        "CROSS_COMPILE": "proton-clang/bin/aarch64-linux-gnu-",
        "CROSS_COMPILE_ARM32": "proton-clang/bin/arm-linux-gnueabi-",
        "LD": "proton-clang/bin/ld.lld",
        "AR": "proton-clang/bin/llvm-ar",
        "NM": "proton-clang/bin/llvm-nm",
        "OBJCOPY": "proton-clang/bin/llvm-objcopy",
        "OBJDUMP": "proton-clang/bin/llvm-objdump",
        "READELF": "proton-clang/bin/llvm-readelf",
        "OBJSIZE": "proton-clang/bin/llvm-size",
        "STRIP": "proton-clang/bin/llvm-strip",
        "LDGOLD": "proton-clang/bin/aarch64-linux-gnu-ld.gold",
        "LLVM_AR": "proton-clang/bin/llvm-ar",
        "LLVM_DIS": "proton-clang/bin/llvm-dis"
      }
    },
    "AnyKernel3": {
      "use": true,
      "release": true,
      "repo": "https://github.com/easterNday/AnyKernel3/",
      "branch": "thyme"
    }
  },
  {
    "kernelSource": {
      "name": "DogDay-KernelSU-Proton-noanykernel-release",
      "repo": "https://codeberg.org/DogDayAndroid/android_kernel_xiaomi_thyme",
      "branch": "lineage-20.0",
      "device": "thyme",
      "defconfig": "thyme_defconfig"
    },
    "withKernelSU": true,
    "toolchains": [
      {
        "repo": "https://github.com/kdrag0n/proton-clang",
        "branch": "master",
        "name": "proton-clang",
        "binPath": ["bin"]
      }
    ],
    "ccache":true,
    "params": {
      "ARCH": "arm64",
      "CC": "proton-clang/bin/clang",
      "externalCommand": {
        "CROSS_COMPILE": "proton-clang/bin/aarch64-linux-gnu-",
        "CROSS_COMPILE_ARM32": "proton-clang/bin/arm-linux-gnueabi-",
        "LD": "proton-clang/bin/ld.lld",
        "AR": "proton-clang/bin/llvm-ar",
        "NM": "proton-clang/bin/llvm-nm",
        "OBJCOPY": "proton-clang/bin/llvm-objcopy",
        "OBJDUMP": "proton-clang/bin/llvm-objdump",
        "READELF": "proton-clang/bin/llvm-readelf",
        "OBJSIZE": "proton-clang/bin/llvm-size",
        "STRIP": "proton-clang/bin/llvm-strip",
        "LDGOLD": "proton-clang/bin/aarch64-linux-gnu-ld.gold",
        "LLVM_AR": "proton-clang/bin/llvm-ar",
        "LLVM_DIS": "proton-clang/bin/llvm-dis"
      }
    },
    "AnyKernel3": {
      "use": false,
      "release": true,
      "repo": "https://github.com/easterNday/AnyKernel3/",
      "branch": "thyme"
    }
  },
  {
    "kernelSource": {
      "name": "DogDay-KernelSU-Proton-anykernel-norelease",
      "repo": "https://codeberg.org/DogDayAndroid/android_kernel_xiaomi_thyme",
      "branch": "lineage-20.0",
      "device": "thyme",
      "defconfig": "thyme_defconfig"
    },
    "withKernelSU": false,
    "toolchains": [
      {
        "repo": "https://github.com/kdrag0n/proton-clang",
        "branch": "master",
        "name": "proton-clang",
        "binPath": ["bin"]
      }
    ],
    "ccache":true,
    "params": {
      "ARCH": "arm64",
      "CC": "proton-clang/bin/clang",
      "externalCommand": {
        "CROSS_COMPILE": "proton-clang/bin/aarch64-linux-gnu-",
        "CROSS_COMPILE_ARM32": "proton-clang/bin/arm-linux-gnueabi-",
        "LD": "proton-clang/bin/ld.lld",
        "AR": "proton-clang/bin/llvm-ar",
        "NM": "proton-clang/bin/llvm-nm",
        "OBJCOPY": "proton-clang/bin/llvm-objcopy",
        "OBJDUMP": "proton-clang/bin/llvm-objdump",
        "READELF": "proton-clang/bin/llvm-readelf",
        "OBJSIZE": "proton-clang/bin/llvm-size",
        "STRIP": "proton-clang/bin/llvm-strip",
        "LDGOLD": "proton-clang/bin/aarch64-linux-gnu-ld.gold",
        "LLVM_AR": "proton-clang/bin/llvm-ar",
        "LLVM_DIS": "proton-clang/bin/llvm-dis"
      }
    },
    "AnyKernel3": {
      "use": true,
      "release": false,
      "repo": "https://github.com/easterNday/AnyKernel3/",
      "branch": "thyme"
    }
  }
]
```

## Individual Configuration Template

```json
{
  "kernelSource": {
    "name": "",
    "repo": "",
    "branch": "",
    "device": "",
    "defconfig": ""
  },
  "withKernelSU": false,
  "toolchains": [
    {
      "repo": "",
      "branch": "",
      "name": "",
      "binPath": []
    }
  ],
  "ccache": false,
  "params": {
    "ARCH": "",
    "CC": "",
    "externalCommand": {}
  },
  "AnyKernel3": {
    "use": false,
    "release": false,
    "repo": "",
    "branch": ""
  }
}
```

## Parameter Parsing

In general, there are the following fields:

| Field Name   | Description                                                                                                                           |
| ------------ | ------------------------------------------------------------------------------------------------------------------------------------- |
| kernelSource | Information about the kernel source code, including name, repository address, branch, and device type.                                |
| withKernelSU | A boolean value indicating whether the `KernelSU` was used.                                                                           |
| toolchains   | An array containing information about the toolchains needed, including repository address, branch, and name.                          |
| ccache       | A boolean value indicating whether the `ccache` tool was used to speed up compile.                                                    |
| params       | An object containing information about the build parameters, including architecture type, cross-compiler, compiler, etc.              |
| AnyKernel3   | An object containing information about building the kernel flash package, including the `AnyKernel3` repository address, branch, etc. |

### Kernel Source Configuration (kernelSource)

| Kernel Source Parameter | Type   | Description                      | Explanation                                                                                                                                  |
| ----------------------- | ------ | -------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| `name`                  | String | Kernel Name                      | Customized, will be used in the release.                                                                                                     |
| `repo`                  | String | Kernel Source Repository Address | The `git` repository address of the kernel source code.                                                                                      |
| `branch`                | String | Kernel Source Branch             | The specified branch of the repository.                                                                                                      |
| `device`                | String | Device Code                      | The device code or name to be compiled, will be used in the release.                                                                         |
| `defconfig`             | String | Kernel Configuration File Name   | The prefix of the corresponding `defconfig` file to be compiled, for example, if the `defconfig` file is `thyme_defconfig`, fill in `thyme`. |

### Toolchain Configuration (toolchains)

This is an array that contains many repository objects of cross-compilation toolchains, and the parameter description of each configuration object is as follows:

| Toolchain Parameter | Type   | Description                  | Explanation                                                                                                                                                                           |
| ------------------- | ------ | ---------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `repo`              | String | Toolchain Repository Address | The `git` repository address of the toolchain.                                                                                                                                        |
| `branch`            | String | Toolchain Branch             | The specified branch of the repository.                                                                                                                                               |
| `url`               | String | Toolchain Download Url       | The download url of the toolchain.                                                                                                                                                    |
| `name`              | String | Toolchain Name               | The name of the folder cloned locally, customized.                                                                                                                                    |
| `binPath`           | Array  | Toolchain Binary File Path   | The path of the `bin` file used during compilation (relative to the path of the cloned folder). It will be converted to an **absolute path** during parameter setting when compiling. |

Therefore, you can use the following forms to obtain the compilation toolchain:

#### 1. Use `Git` to pull the toolchain

```json
"toolchains": [
  {
    "repo": "https://github.com/kdrag0n/proton-clang",
    "branch": "master",
    "name": "proton-clang",
    "binPath": ["./bin"]
  }
]
```

#### 2. Use `wget` to download the toolchain

In this way, you can get the compiled toolchain compressed package in `.zip` | `.tar` | `.tar.gz` | `.rar` format.

```json
"toolchains": [
  {
    "url": "https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/heads/master-kernel-build-2022/clang-r450784d.tar.gz",
    "name": "clang",
    "binPath": ["./bin"]
  },
  {
    "url": "https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/+archive/refs/tags/android-12.1.0_r27.tar.gz",
    "name": "gcc",
    "binPath": ["bin"]
  }
]
```

#### 3. Mixed mode (using `Git` and `wget` at the same time)

```json
"toolchains": [,
  {
    "repo": "https://gitlab.com/ThankYouMario/android_prebuilts_clang-standalone/",
    "branch": "11",
    "name": "clang",
    "binPath": ["bin"]
  },
  {
    "url": "https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/+archive/refs/tags/android-12.1.0_r27.tar.gz",
    "name": "gcc",
    "binPath": ["bin"]
  }
]
```

### Compilation Parameters (params)

| Compilation Parameter | Type   | Description           | Explanation                                                            |
| --------------------- | ------ | --------------------- | ---------------------------------------------------------------------- |
| `ARCH`                | String | Architecture          | The architecture of the device, which can be queried using `uname -m`. |
| `CC`                  | String | C Compiler Path       | The compiler used, usually `clang` or `gcc`.                           |
| `externalCommand`     | Object | External Command Path | Additional parameter settings required for compilation.                |

For the `externalCommand` part, here is an example of the command that may be used during compilation:

```sh
make -j$(nproc --all) \
      O=out \
      ARCH=arm64 \
      CC=clang \
      CLANG_TRIPLE=aarch64-linux-gnu- \
      CROSS_COMPILE=aarch64-linux-gnu- \
      CROSS_COMPILE_ARM32=arm-linux-gnueabi-
```

The `-j` and `O=out` parts will be automatically configured by the compilation script, and the `ARCH` and `CC` parts correspond to the above configuration. The other parts correspond to the `externalCommand` part, so the corresponding configuration for the toolchains part should be:

```json
"params": {
  "ARCH": "arm64",
  "CC": "clang",
  "externalCommand": {
    "CLANG_TRIPLE": "aarch64-linux-gnu-",
    "CROSS_COMPILE": "proton-clang/bin/aarch64-linux-gnu-",
    "CROSS_COMPILE_ARM32": "proton-clang/bin/arm-linux-gnueabi-"
  }
}
```

### Kernel Flashing Package Configuration(AnyKernel3)

| AnyKernel3 Parameter | Type    | Description                     | Explanation                                                                                                                   |
| -------------------- | ------- | ------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| `use`                | Boolean | Whether to use AnyKernel3       | If set to `false`, the corresponding kernel flashing package will not be packaged                                             |
| `release`            | Boolean | Whether it is a release version | Only effective when `use` is set to `true`. If set to `false`, the corresponding kernel flashing package will not be released |
| `repo`               | String  | AnyKernel3 repository address   | The repository address of the `Anykernel3` used                                                                               |
| `branch`             | String  | AnyKernel3 branch               | The specified branch of the corresponding repository                                                                          |
