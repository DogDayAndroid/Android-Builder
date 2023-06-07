<div align = center>

<img src="./.assets/DogDayAndroid.png" width="200" height="175" alt="banner">

<h1>构建属于你自己的安卓内核镜像</h1>

![License](https://img.shields.io/static/v1?label=License&message=BY-NC-SA&logo=creativecommons&color=green)
![Language](https://img.shields.io/github/languages/top/DogDayAndroid/Android-Kernel-Builder)
![Issues](https://img.shields.io/github/issues/DogDayAndroid/Android-Kernel-Builder)
![Pull Requests](https://img.shields.io/github/issues-pr/DogDayAndroid/Android-Kernel-Builder)


这个 Github Action 可以帮助你构建内核。它可以从一个配置文件中读取多个内核源，并使用不同的工具链构建它们。此外，它还支持使用 KernelSU 进行内核补丁，并上传构建好的内核镜像。
<br>

---

**[<kbd> <br>  配置文件使用方法  <br> </kbd>](#配置文件解析)** 
**[<kbd> <br>  快速开始  <br> </kbd>](#使用方法)** 
**[<kbd> <br>  本地构建  <br> </kbd>](#本地构建)**

---
</div>

# Github Action

该 Action 包含两个作业：`Set-repos` 和 `Build-Kernel`。

Set-repos 作业从配置文件中读取内核源，并将其输出到 Build-Kernel 作业中。Build-Kernel 作业使用输出的内核源构建内核，并上传构建好的内核镜像。

## 启动方式

| 事件名称          | 描述           |
| ----------------- | -------------- |
| workflow_dispatch | 手动触发构建。 |

## 构建流程

| 构建步骤               | 描述                       |
| ---------------------- | -------------------------- |
| Checkout               | 检出代码                   |
| Generate Matrix        | 从配置文件中生成内核源矩阵 |
| Create working dir     | 创建工作目录               |
| Install prerequisites  | 安装构建所需的依赖项       |
| Clone kernel source    | 克隆内核源代码             |
| Get toolchains         | 获取工具链                 |
| Set args               | 设置构建参数               |
| Update KernelSU (可选) | 使用 KernelSU 进行内核补丁 |
| Make defconfig         | 生成内核配置文件           |
| Build kernel           | 构建内核                   |
| Upload Image           | 上传内核镜像               |
| Upload Image.gz        | 上传内核镜像压缩文件       |
| Upload dtb             | 上传设备树文件             |
| Upload dtbo.img        | 上传设备树覆盖文件         |

## 配置文件解析

下面是一个基本的配置文件例子:

```json
[
  {
    "kernelSource": {
      "name": "DogDayAndroid",
      "repo": "https://codeberg.org/DogDayAndroid/android_kernel_xiaomi_thyme",
      "branch": "lineage-20.0",
      "device": "thyme"
    },
    "withKernelSU": false,
    "toolchains": [
      {
        "repo": "https://android.googlesource.com/platform/prebuilts/gas/linux-x86",
        "branch": "master",
        "name": "gas"
      },
      {
        "repo": "https://gitlab.com/ThankYouMario/android_prebuilts_clang-standalone/",
        "branch": "11",
        "name": "clang"
      }
    ],
    "params": {
      "ARCH": "arm64",
      "CROSS_COMPILE": "aarch64-linux-gnu-",
      "CROSS_COMPILE_ARM32": "arm-linux-gnueabi-",
      "CROSS_COMPILE_COMPAT": "arm-linux-gnueabi-",
      "CLANG_TRIPLE": "aarch64-linux-gnu-",
      "AR": "",
      "CC": "clang"
    }
  },
  {
    "kernelSource": {
      "name": "DogDay-KernelSU",
      "repo": "https://codeberg.org/DogDayAndroid/android_kernel_xiaomi_thyme",
      "branch": "lineage-20.0",
      "device": "thyme"
    },
    "withKernelSU": true,
    "toolchains": [
      {
        "repo": "https://android.googlesource.com/platform/prebuilts/gas/linux-x86",
        "branch": "master",
        "name": "gas"
      },
      {
        "repo": "https://gitlab.com/ThankYouMario/android_prebuilts_clang-standalone/",
        "branch": "11",
        "name": "clang"
      }
    ],
    "params": {
      "ARCH": "arm64",
      "CROSS_COMPILE": "aarch64-linux-gnu-",
      "CROSS_COMPILE_ARM32": "arm-linux-gnueabi-",
      "CROSS_COMPILE_COMPAT": "arm-linux-gnueabi-",
      "CLANG_TRIPLE": "aarch64-linux-gnu-",
      "AR": "",
      "CC": "clang"
    }
  }
]
```

这段 JSON 代码描述了一个构建流程的配置，其中包括以下内容：

| 字段名称     | 描述                                                                               |
| ------------ | ---------------------------------------------------------------------------------- |
| kernelSource | 内核源代码的相关信息，包括名称、仓库地址、分支和设备类型。                         |
| withKernelSU | 一个布尔值，表示是否使用了名为 `KernelSU` 的内核补丁工具。                         |
| toolchains   | 一个数组，包含了需要用到的工具链的相关信息，包括仓库地址、分支和名称。             |
| params       | 一个对象，包含了构建参数的相关信息，其中包括了架构类型、交叉编译器、编译器等信息。 |

`params` 对象中的具体参数信息可以用表格展示：

| 参数名称             | 描述                                                                      |
| -------------------- | ------------------------------------------------------------------------- |
| ARCH                 | 架构类型，此处为 `arm64`。                                                |
| CROSS_COMPILE        | 交叉编译器前缀，此处为 `aarch64-linux-gnu-`。                             |
| CROSS_COMPILE_ARM32  | 用于 32 位兼容支持的交叉编译器前缀，此处为 `arm-linux-gnueabi-`。         |
| CROSS_COMPILE_COMPAT | 用于指定编译 32 位兼容支持的交叉编译器前缀，此处为 `arm-linux-gnueabi-`。 |
| CLANG_TRIPLE         | 用于指定 clang 编译器的三元组（triple），此处为 `aarch64-linux-gnu-`。    |
| AR                   | 用于指定静态库的归档程序，此处为空。                                      |
| CC                   | 用于指定 C 编译器，此处为 `clang`。                                       |

这些配置信息将在构建流程中使用，以自动化地构建出特定的内核镜像文件。

# 使用方法

本项目的基础使用方法如下：

1. 在 GitHub 上 `fork` 本项目

2. 通过 Github 网页或者拉取到本地修改 `repos.json` 文件，并提交修改

3. 查看 Github 网页的 `Action` 页面，找到 `Build kernels` 并 `Run workflow`

4. 等待编译完成，即可进入对应页面下载编译产物

5. 使用您喜欢的打包软件进行内核打包([AnyKernel3](https://github.com/osm0sis/AnyKernel3)、[Android-Image-Kitchen](https://github.com/osm0sis/Android-Image-Kitchen)、[MagiskBoot](https://github.com/topjohnwu/Magisk/releases) 等)

![Artifacts](./.assets/artifacts.png)

# 本地构建

如果您并不想在 `Github` 上重复执行 `Action`，您可以利用 [nektos/act](https://github.com/nektos/act) 来在本地环境里测试本构建流程并输出。

## 普通本地构建(内核源码等使用 `Git` 拉取)

这种方式是推荐的本地测试流程，您只需要安装 [nektos/act](https://github.com/nektos/act) 并执行如下指令:

```sh
# 将构建文件收集到 /tmp/artifacts 文件夹：
act --artifact-server-path /tmp/artifacts
```

如果您需要放在本地你喜欢的位置，请更改 `/tmp/artifacts` 为您喜欢的目录即可。

如果中途报错，请加入参数 `-v` 重新执行获取错误报告并提交 `issue` ，具体命令如下:

```sh
# 将构建文件收集到 /tmp/artifacts 文件夹：
act --artifact-server-path /tmp/artifacts -v
```

## 完全本地构建(内核源码等均为本地存储)

用上述方式构建仍然需要内核源码等存储在云端，如果您一定有要**全部**本地构建的需求，请考虑通过如下方式构建：

1. 搭建本地 `Gitea` 或 `Gitlab` 等 `Git` 服务。随后修改配置文件地址为本地服务地址。

2. 在本地利用 `git daemon` 指令建立一个二级镜像。

此处仅仅提供思路，并不提供具体教程。

# 致谢

- [weishu](https://github.com/tiann) : KernelSU 的开发者
- [AKR 安卓开发者社区](https://www.akr-developers.com/) ： 编译教程提供
- [DogDayAndroid/KSU_Thyme_BuildBot](https://github.com/DogDayAndroid/KSU_Thyme_BuildBot) : 此项目的前身
- [xiaoleGun/KernelSU_Action](https://github.com/xiaoleGun/KernelSU_Action) ： 借鉴部分 Github Action
- [UtsavBalar1231/Drone-scripts](https://github.com/UtsavBalar1231/Drone-scripts) ： 借鉴部分 Github Action

# 贡献者

<a href="https://github.com/DogDayAndroid/Android-Kernel-Builder/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=DogDayAndroid/Android-Kernel-Builder" alt="contributors"/>
</a>

# Star 历史

[![Star History](https://starchart.cc/DogDayAndroid/Android-Kernel-Builder.svg)](https://starchart.cc/DogDayAndroid/Android-Kernel-Builder)

# 许可

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="知识共享许可协议" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />本作品采用<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">知识共享署名-非商业性使用-相同方式共享 4.0 国际许可协议</a>进行许可。
