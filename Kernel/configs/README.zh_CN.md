# 内核编译配置文件编写

[English](./README.md) | 中文文档

## 基本配置文件案例

每个内核编译配置文件都是一个以 `.config.json` 结尾的 `Json` 文件，文件中是一个数组，数组中的每个 `item` 就是我们的内核编译配置。

<details>
  <summary>配置模板</summary>

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

建议将不同的设备内核存储在不同的 `Json` 文件中，其中的每一条配置可以不同，这样便于对内核配置进行修改、查看和分类。

## 配置参数解析

每个配置模板均由以下几个部分组成：

| 字段名称     | 描述                                                                                           |
| ------------ | ---------------------------------------------------------------------------------------------- |
| kernelSource | 内核源代码的相关信息，包括名称、仓库地址、分支和设备类型。                                     |
| toolchains   | 一个数组，包含了需要用到的工具链的相关信息，包括仓库地址、分支和名称。                         |
| enableCcache | 一个布尔值，表示是否使用了名为 `ccache` 的编译工具来加速编译。                                 |
| params       | 一个对象，包含了构建参数的相关信息，其中包括了架构类型、交叉编译器、编译器等信息。             |
| AnyKernel3   | 一个对象，包含了构建内核刷机包的相关信息，其中包括了使用的 `AnyKernel3` 仓库地址、分支等信息。 |
| enableKernelSU | 一个布尔值，表示是否使用了名为 `KernelSU` 的内核补丁。                                         |
| enableLXC | 一个布尔值，表示是否开启 `Docker` 支持。                                         |

### 内核源码配置(kernelSource)

```json
"kernelSource": {
  "name": "",       // 你喜欢的名称，无任何影响，一般设定为 设备名字+编译工具 链版本
  "repo": "",       // 内核源码的仓库地址
  "branch": "",     // 对应内核源码仓库的 分支 名称
  "device": "",     // 对应的设备编号
  "defconfig": ""   // 对应的 defconfig 文件相对路径
}
```

`name` 部分对于整个编译流程来说是没有影响的，因此理论上你可以随意设定。

`repo`, `branch` 用于克隆内核源码，我们会默认克隆源码下的所有子模块来保证内核的完整性，克隆代码如下：

```bash
git clone --recursive --depth=1 -j $(nproc) --branch <branch> <repo> <name>
```

`defconfig` 中填写的内容是您的 `defconfig` 文件相对于 `arch/arm64/configs` 或 `arch/arm/configs` 文件夹的相对路径，这样做的原因是因为部分 `defconfig` 文件可能会存在于子目录中，`make` 的时候我们需要显示指定他的相对路径。

下面是一个基本的例子:

```json
"kernelSource": {
  "name": "Mi6X",
  "repo": "https://github.com/Diva-Room/Miku_kernel_xiaomi_wayne",
  "branch": "TDA",
  "device": "wayne",
  "defconfig": "vendor/wayne_defconfig"
}
```

这个内核是**小米6X**的内核源码，网页打开其 `Github` 地址后，我们看到它的主要分支是 `TDA`，同时其 `defconfig` 文件位于 `/arch/arm64/configs/vendor/wayne_defconfig` 内，因此设定 `defconfig` 为 `vendor/wayne_defconfig` 。

### 工具链配置(toolchains)

交叉编译工具链是我们编译内核时的重要工具，但是编译工具链的下载形式五花八门，可以使用 `git` 拉取下载，也可以通过下载得到，因此对于不同的获取方式，我们分别作了适配：

---

#### 1. 使用 `Git` 拉取编译工具链

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

这部分的配置其实类似于内核源码的配置，我们同样会使用如下命令来从仓库中拉取源码：

```bash
git clone --recursive --depth=1 -j $(nproc) --branch <branch> <repo> <name>
```

但是这部分中新增了一个 `binaryEnv`, 这是用于给我们的编译工具链添加全局环境变量设定的，例如此处的 `./bin`，添加内容后，环境变量中会增加编译工具链下的 `bin` 文件夹，这对于我们的内核编译大有裨益。

---

#### 2. 使用 `Wget` 下载编译工具链

通过这种方式我们可以获取到 `.zip` | `.tar` | `.tar.gz` | `.rar` 格式的编译工具链压缩包。

```json
"toolchains": [
  {
    "name": "clang",
    "url": "https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/heads/master-kernel-build-2022/clang-r450784d.tar.gz",
    "binaryEnv": ["./bin"]
  },
  {
    "name": "gcc",
    "url": "https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/+archive/refs/tags/android-12.1.0_r27.tar.gz",
    "binaryEnv": ["bin"]
  }
]
```

`Action` 会下载并解压他们，同时这部分中也会有 `binaryEnv`, 其作用和上述作用类似，因此不再赘述。

---

这两种方式并非鱼与熊掌不可得兼的，如果我们既需要 `Git` 拉取又需要 `Wget` 下载的编译工具链，我们也可以像如下配置一样将其混用：

```json
"toolchains": [,
  {
    "name": "clang",
    "repo": "https://gitlab.com/ThankYouMario/android_prebuilts_clang-standalone/",
    "branch": "11",
    "binaryEnv": ["bin"]
  },
  {
    "name": "gcc",
    "url": "https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/+archive/refs/tags/android-12.1.0_r27.tar.gz",
    "binaryEnv": ["bin"]
  }
]
```

### 编译参数(params)

#### 基本配置

通常我们在本地进行内核编译的时候，会使用形似如下的编译命令：

```sh
make -j$(nproc --all) \
      O=out \
      ARCH=arm64 \
      CC=clang \
      CLANG_TRIPLE=aarch64-linux-gnu- \
      CROSS_COMPILE=aarch64-linux-gnu- \
      CROSS_COMPILE_ARM32=arm-linux-gnueabi-
```

因此，我们的编译参数配置也以类似的方式来进行配置：

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

其中 `-j` 和 `O=out` 这一部分会由编译脚本自动配置好，因此配置中并不用进行设置。`ARCH` 以及 `CC` 部分对应上面的指令部分，其他的更多参数则对应 `externalCommand` 部分，例如 `markw` 的编译参数配置：

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

#### 开启 `ccache` 加速编译

内核编译过程中，如果反复的编译会非常耗费我们的时间，`ccache` 使得我们可以可以复用以前编译时的一些中间件的缓存从而加快编译的速度，例如上一小节中的编译命令开启 `ccache` 后应为:

```sh
make -j$(nproc --all) \
      O=out \
      ARCH=arm64 \
      CC="ccache clang" \
      CLANG_TRIPLE=aarch64-linux-gnu- \
      CROSS_COMPILE=aarch64-linux-gnu- \
      CROSS_COMPILE_ARM32=arm-linux-gnueabi-
```

这样我们就引出了一个单独的配置参数 `enableCcache`，我们只需要在配置的时候将 `enableCcache` 设置为 `true` 即可实现同样的命令：

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

**请注意，`enableCcache` 是一条独立的配置，请确保其存在，如果您不使用请设定为 `false` 而不是直接删除。**

### 内核刷机包配置(AnyKernel3)

内核打包可以通过 [AnyKernel3](https://github.com/osm0sis/AnyKernel3)、[Android-Image-Kitchen](https://github.com/osm0sis/Android-Image-Kitchen)、[MagiskBoot](https://github.com/topjohnwu/Magisk/releases) 等工具来实现，目前本项目仅支持 `AnyKernel3`，其配置如下:

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

这段配置中，我使用了自定义的 `AnyKernel3` 来进行打包，如果您不想额外的 `fork` 一个仓库来实现的话，可以选择删除 `custom` 字段来使用原版的 `AnyKernel3` 来打包您的内核，删除后的配置如下：

```json
"AnyKernel3": {
  "use": true,
  "release": true
}
```

配置中的 `use` 表示您是否使用 `AnyKernel3` 来进行打包，`release` 表示您是否将打包后的刷机包发布出来，`release` 当且仅当 `AnyKernel3` 设置为 `true` 的时候才生效，否则默认为 `false`。

### 额外的编译参数设定

#### KernelSU

使用 `"enableKernelSU": true,` 来控制是否启用 `KernelSU`，设置为 `false` 则不启用。

#### LXC Docker

使用 `"enableLXC": false` 来控制是否启用 `Docker` 支持，设置为 `true` 则启用。

## 参考

- [DogDayAndroid/KSU_Thyme_BuildBot](https://github.com/DogDayAndroid/KSU_Thyme_BuildBot) : 此项目的前身
- [UtsavBalar1231/Drone-scripts](https://github.com/UtsavBalar1231/Drone-scripts) ： 参考其编译过程
- [xiaoleGun/KernelSU_Action](https://github.com/xiaoleGun/KernelSU_Action) ： 参考其原版 AnyKerne3 打包部分
