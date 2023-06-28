<div align = center>

<img src="./.assets/DogDayAndroid.png" width="200" height="175" alt="banner">

<h1>Build Your Own Kernel with Github Action</h1>

English | [中文](./README_cn.md)

![License](https://img.shields.io/static/v1?label=License&message=BY-NC-SA&logo=creativecommons&color=green)
![Language](https://img.shields.io/github/languages/top/DogDayAndroid/Android-Kernel-Builder)
![Issues](https://img.shields.io/github/issues/DogDayAndroid/Android-Kernel-Builder)
![Pull Requests](https://img.shields.io/github/issues-pr/DogDayAndroid/Android-Kernel-Builder)
<br>

This Github Action helps you build kernels. It reads multiple kernel sources from a configuration file and builds them using different toolchains. Additionally, it supports patching the kernel with KernelSU and uploading the built kernel image.
<br>

---

**[<kbd> <br>  Configure  <br> </kbd>](#configuration-file-syntax)** 
**[<kbd> <br>  Quick Start  <br> </kbd>](#how-to-use)** 
**[<kbd> <br>  Local testing  <br> </kbd>](#local-testing)**

---

</div>

# Github Action

This action contains two jobs: `Set-repos` and `Build-Kernel`.

The `Set-repos` job reads the kernel sources from the configuration file and outputs them to the `Build-Kernel` job. The `Build-Kernel` job uses the outputted kernel sources to build the kernels and upload the built kernel images.

## Trigger

| Event name        | Description  |
| ----------------- | ------------ |
| workflow_dispatch | Manually run |

## Workflow

| Step                    | Description                                                                |
| ----------------------- | -------------------------------------------------------------------------- |
| Install prerequisites   | Install the necessary dependencies for building the kernel                 |
| Setup Anykernel3        | Clone the Anykernel3 repository to prepare for packaging the kernel        |
| Clone kernel source     | Clone the kernel source code repository for the Android device             |
| Get toolchains          | Obtain the required cross-compilation toolchains for building the kernel   |
| Set args                | Set the necessary build parameters for the kernel                          |
| Update KernelSU         | Update the KernelSU tool to ensure compatibility with the new kernel       |
| Make defconfig          | Generate the kernel configuration file                                     |
| Build kernel            | Compile the kernel source code to create the kernel image                  |
| Upload Image            | Upload the kernel image file to a designated location                      |
| Upload Image.gz         | Upload the compressed kernel image file to a designated location           |
| Upload dtb              | Upload the device tree blob file to a designated location                  |
| Upload dtbo.img         | Upload the device tree overlay image file to a designated location         |
| Pack AnyKernel3.zip     | Package the kernel image and device tree files into an Anykernel3 zip file |
| Upload AnyKernel3 image | Upload the Anykernel3 zip file to a designated location                    |
| Create GitHub Release   | Create a new release on GitHub to share the kernel with the community      |

## Configuration File Syntax

<details>
  <summary>Example configuration file</summary>
  
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

</details>

<details>
  <summary>Individual Configuration Template</summary>

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

</details>

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

# How to use

This project's basic usage is as follows:

1. Fork this project on GitHub.

2. Modify the `repos/repos*.json` file through the Github website or pull it to your local machine and commit the changes.

3. Go to the `Action` page on Github and find `Build kernels`, then `Run workflow`.

> **Notice**
>
> In this step, you may encounter the following error when executing `softprops/action-gh-release@v1`:
>
> ```
> 👩‍🏭 Creating new GitHub release for tag v20230619.7...
> ⚠️ GitHub release failed with status: 403
> undefined
> retrying... (2 retries remaining)
> 👩‍🏭 Creating new GitHub release for tag v20230619.7...
> ⚠️ GitHub release failed with status: 403
> undefined
> retrying... (1 retries remaining)
> 👩‍🏭 Creating new GitHub release for tag v20230619.7...
> ⚠️ GitHub release failed with status: 403
> undefined
> retrying... (0 retries remaining)
> ❌ Too many retries. Aborting...
> Error: Too many retries.
> ```
>
> The reason for this error is related to workflow permissions:
>
> ![workflow permissions](./.assets/FAQ/workflow%20permissions.png)
>
> Complete the permission settings and then you can publish your own `Release` normally.

4. Wait for the compilation to finish, then download the compiled product from the corresponding page.

5. Use your preferred packaging software to package the kernel ([AnyKernel3](https://github.com/osm0sis/AnyKernel3), [Android-Image-Kitchen](https://github.com/osm0sis/Android-Image-Kitchen), [MagiskBoot](https://github.com/topjohnwu/Magisk/releases), etc.)

![Artifacts](./.assets/artifacts.png)

# Local testing

If you don't want to run the action on `Github`, you can use [nektos/act](https://github.com/nektos/act) to test this workflow locally and output the files.

## Normal local build (kernel source code is fetched using Git)

This is the recommended local testing process. Simply install [nektos/act](https://github.com/nektos/act) and run the following command:

```sh
# Collect artifacts to /tmp/artifacts folder:
act --artifact-server-path /tmp/artifacts
```

If you want to store the artifacts in a different location, change `/tmp/artifacts` to your preferred directory.

If there are errors, use the `-v` flag to generate an error report and submit an issue. Here's the command:

```sh
# Collect artifacts to /tmp/artifacts folder:
act --artifact-server-path /tmp/artifacts -v
```

## Full local build (kernel source code is stored locally)

If you need to perform a completely local build, consider building as follows:

1. Set up a local `Gitea` or `Gitlab` Git service and modify the configuration file address to point to the local service address.

2. Use `git daemon` to create a secondary image locally.

This is just a suggestion, and we do not provide a specific guide.

# TODO list

- Use `MagiskBoot` to generate `boot.img`
- Web page for configuring profiles

# Acknowledgments

- [weishu](https://github.com/tiann) : Developer of KernelSU
- [AKR Android Developer Community](https://www.akr-developers.com/) ： Provides build tutorials
- [DogDayAndroid/KSU_Thyme_BuildBot](https://github.com/DogDayAndroid/KSU_Thyme_BuildBot) : Predecessor of this project
- [xiaoleGun/KernelSU_Action](https://github.com/xiaoleGun/KernelSU_Action) ： Drawing on some Github Actions
- [UtsavBalar1231/Drone-scripts](https://github.com/UtsavBalar1231/Drone-scripts) ： Drawing on some Github Actions

# Contributor

<a href="https://github.com/DogDayAndroid/Android-Kernel-Builder/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=DogDayAndroid/Android-Kernel-Builder" alt="contributors"/>
</a>

# Star history

[![Star History](https://starchart.cc/DogDayAndroid/Android-Kernel-Builder.svg)](https://starchart.cc/DogDayAndroid/Android-Kernel-Builder)

# License

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>.
