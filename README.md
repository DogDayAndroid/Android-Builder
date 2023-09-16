<div align = center>

<img src="./.assets/logo.svg" width="200" height="150" alt="banner">

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

# Development progress

- [x] Web page configuration Json compilation configuration file (to be released soon)
- [ ] Use `MagiskBoot` to generate `boot.img`
- [ ] Use script to compile kernel locally
- [ ] Webpage for online kernel building
- [x] Support origin / custom AnyKernel3
- [x] Custom build info
- [x] Suppor `Docker`

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

# Configuration File Syntax

See [repo configuration file guidance](./repos/README.md).

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
