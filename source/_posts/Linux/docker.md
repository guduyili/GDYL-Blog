---
title: Docker       
date: 2025-02-25
updated: 2025-02-25
categories: 
- Linux
tag:
- learning
---

<!-- toc -->

[TOC]

[参考文献]("https://blog.csdn.net/u010698107/article/details/122641323")

# Docker

## 名称空间

```shell
$ docker run -it busybox /bin/sh
```

`-it`一般一起使用，实现和docker容器进行交互。 `-i`标识以交互模式运行容器，`-t`表示为容器分配一个伪输入终端。`/bin/sh`是要在Docker中运行该的程序

容器内`/bin/sh`命令的进程ID为1，这表明容器里执行的`/bin/sh` 已经和宿主机"隔离"了，而在宿主机真实的进程空间里，这个进程的 PID 还是真实的数值，这就是Namespace 技术产生的效果，它只是修改了进程视图，容器内只能“看到”某些指定的进程。而对宿主机来说，这个`/bin/sh` 和其它进程没什么区别，我们可以在宿主机中查看这个`/bin/sh`进程的ID

```shell
$ docker ps | grep busybox
ef0b47c6f9bb   busybox             "/bin/sh"                16 minutes ago   Up 16 minutes             hungry_booth
$ 
$ docker top ef0b47c6f9bb
UID                 PID                 PPID                C                   STIME               TTY                 TIME                CMD
root                8786                8768                0                   11:20               pts/0               00:00:00            /bin/sh
$ 
$ ps ajx | grep /bin/sh | grep -v grep
  2453   2584   2584   2584 ?            -1 Ss       0   0:00 /usr/bin/ssh-agent /bin/sh -c exec -l /bin/bash -c "env GNOME_SHELL_SESSION_MODE=classic gnome-session --session gnome-classic"
  8367   8750   8750   8367 pts/3      8750 Sl+      0   0:00 docker run -it busybox /bin/sh
  8768   8786   8786   8786 pts/0      8786 Ss+      0   0:00 /bin/sh
		
```

上面介绍了进程名称空间（PID Namespace），还有其他类型的名称空间：Mount、UTS、IPC、Network 、User等名称空间。Network Namespace用于实现网络隔离，而有时候容器之间是需要通信的，比如连接数据库。不同Namespace之间的通信是通过Veth 设备对和网桥来实现的，比如你查看安装了docker 的服务器的网络设备会发现叫做 docker0 的网桥和很多随机名称的 veth 设备。

接下来介绍容器是如何解决限制问题的。

## Cgroups

使用Namespace技术之后，为什么还需要进行资源限制呢？

以前面介绍的`/bin/sh`进程为例，虽然进行了进程隔离，而在宿主机中，PID为8786的进程与其他所有进程之间依然是平等的竞争关系，也就是说，容器中进程使用的资源（CPU、内存等）可能随时被宿主机上的其他进程（或者其他容器的进程）占用。为了保证服务正常运行，需要进行资源限制。

容器使用 Cgroups 来限制一个进程能够使用的资源，Linux Cgroups （Linux Control Group）可以实现资源调度（资源限制、优先级控制等），限制进程可以使用的资源上限，比如CPU、memory、IO、网络带宽等。

cgroups 以文件的方式提供应用接口，Cgroups的默认挂载点在`/sys/fs/cgroup` 路径下:

## 联合文件系统

Docker镜像技术是docker的重要创新，其核心就是联合文件系统，大大简化了应用的更新和部署。

![img](https://s2.loli.net/2025/02/25/zGCfaXy1ti64ndR.png)

#### bootfs和rootfs

一个典型的 Linux 系统至少需要包含bootfs（boot file system）和rootfs（root file system）两个文件系统：

- bootfs包含 boot loader 和 kernel，也就是说相同内核的不同的 Linux 发行版本的bootfs 相同，而rootfs 不同。
- rootfs（根文件系统）是一个操作系统的所有文件和目录，包含典型的目录结构，比如/dev, /proc, /bin, /etc, /lib, /usr等。

在docker容器技术中，宿主机上的所有容器共享主机系统的 bootfs，也就是共享宿主机的内核。换句话说，如果你配置了内核参数，该机器上的所有容器都会受到影响，这也是容器相比于虚拟机的主要缺陷之一。

每个容器有自己的 rootfs，也就是容器镜像，它是挂载在容器根目录上，用来为容器进程提供隔离后执行环境的文件系统。

下面进入Jenkins容器中看看有哪些目录：

```
$ docker exec -it -u root jenkins bash
```

可以看到容器的根目录挂载了一个完整操作系统的文件系统，因此在打包时将应用，以及应用运行所需要的所有依赖都封装在了一起，这保证了容器的“一致性”，部署非常便利。

结合使用 Mount Namespace 和 rootfs，容器就能够为进程构建出一个完善的文件系统隔离环境。在 rootfs 的基础上，Docker 提出了多个增量 rootfs 联合挂载一个完整 rootfs 的方案，这就是容器镜像中“层”的概念，下面介绍docker的镜像分层系统。

通常情况下，我们会对已有的镜像进行修改，比如应用升级。Docker 在镜像的设计中，引入了层（layer）的概念。也就是说，用户制作镜像的每一步操作，都会生成一个层，也就是一个增量 rootfs，而修改时不会修改下层镜像（只读层），修改产生的内容会以增量的方式出现在可读写层中，这一层会存放你增、删、改rootfs 后产生的增量。也就是说可读写层只记录对只读层的更改，这样镜像会一层一层的重叠起来。

这种对容器镜像进行增量式的操作，大大减少了容器镜像占用的空间，比较轻量级，加上它的“一致性”特性，使得docker成为热点项目，Docker 公司在 2014~2016 年间迅猛发展。

docker 的这种镜像分层思想是通过联合文件系统来实现的，目前docker支持多种联合文件系统，包括AuFS，device mapper，overlayFS，overlayFS2等。

## docker镜像结构

```shell
$ docker image inspect jenkins/jenkins
.....
"GraphDriver": {
            "Data": {
                "LowerDir": "/var/lib/docker/overlay2/2831aec4f79dce47c65502d44c3ac7943de8cac3673af33734fe96853b3fa72c/diff:/var/lib/docker/overlay2/06a6068894a4b1003642f81a1c9e621f28c3f658375e1736a05e8decfb35fa74/diff:/var/lib/docker/overlay2/cb8b816fcdc3b2d5ae2ad8d5bd96e77dd0cad7b085f115f9a82cceac0fb5cc21/diff:/var/lib/docker/overlay2/d12760a8287d5556fc7fb8eff16cb0a13be008eb5df9eef6740973acd42c4d75/diff:/var/lib/docker/overlay2/f6ed744b1f83c0aec623b67fd7ad4826d87d9cfbe96b7511ffc10538c551d709/diff:/var/lib/docker/overlay2/f98a07ed1507ee0f85d3d15c49bb2f08317090be9538779cc3be077a7f5d26a0/diff:/var/lib/docker/overlay2/3c47c55df47cb76fe6b0affe44a54b3fc282d9cddc6e8e91ee8d37fee153ad32/diff:/var/lib/docker/overlay2/f590962d115ad3a0b9ce29e3813d07f941ebc978955d3f0e878107873286c6ed/diff:/var/lib/docker/overlay2/4fc791fa5d63311f24c26c4ed099bcad5bdfba21878a62ba3b703584624b52ce/diff:/var/lib/docker/overlay2/71182ef801d593dc0515a1a023f7d806128b626d7a70c28ca8e3954c307c9850/diff:/var/lib/docker/overlay2/bc728058a9fd4473b335266c51f9b17fac47b1caba4611ed22ade419b4f8134c/diff:/var/lib/docker/overlay2/4d177d19504db3444f18b8d7210ee8fcbaf8f3a9e308307764a324ef0e11fa07/diff:/var/lib/docker/overlay2/7987d4111412b1918ef9cb1f9783b13266ffad06db4dc468b8d965f20803cb4e/diff:/var/lib/docker/overlay2/e694ab0894df35db1c9ca8e7e24a7026bbcd349954808b16a7cee8fcb57c73d3/diff:/var/lib/docker/overlay2/94800468c0d78d4b5d25fb0fde1308543b5a82266e941c7292244bd40476b907/diff:/var/lib/docker/overlay2/2700dd307c1887eadc091c2e5e4c0f98cf45b10e84a5d8b4774914d718ee2194/diff:/var/lib/docker/overlay2/1775daf31e9234afec3143d5b902cc6a2d298a5e251e26443dacbb3f27267ed8/diff:/var/lib/docker/overlay2/491b963dedf2f9953afeeda5bb16717ef8a9e9b24eb22f01ba30ea6e8e1f56db/diff:/var/lib/docker/overlay2/4d335a15bbfe5484698feba460f84b8635191cb4c30f5048ae4d23c2b7fa64fe/diff",
                "MergedDir": "/var/lib/docker/overlay2/cf15ec1cc4c49db1af786f5ddd9a647fe75d14cb9855a045846119b0c1175e98/merged",
                "UpperDir": "/var/lib/docker/overlay2/cf15ec1cc4c49db1af786f5ddd9a647fe75d14cb9855a045846119b0c1175e98/diff",
                "WorkDir": "/var/lib/docker/overlay2/cf15ec1cc4c49db1af786f5ddd9a647fe75d14cb9855a045846119b0c1175e98/work"
            },
            "Name": "overlay2"
        },
        "RootFS": {
            "Type": "layers",
            "Layers": [
                "sha256:7948c3e5790c6df89fe48041fabd8f1c576d4bb7c869183e03b9e3873a5f33d9",
                "sha256:4d1ab3827f6b69f4e55bd69cc8abe1dde7d7a7f61bd6e32c665f12e0a8efd1c9",
                "sha256:69dfa7bd7a92b8ba12a617ff56f22533223007c5ba6b3a191c91b852320f012e",
                "sha256:01727b1a72df8ba02293a98ab365bb4e8015aefadd661aaf7e6aa76567b706b9",
                "sha256:e43c0c41b833ec88f51b6fdb7c5faa32c76a32dbefdeb602969b74720ecf47c9",
                "sha256:bd76253da83ab721c5f9deed421f66db1406d89f720387b799dfe5503b797a90",
                "sha256:d81d8fa6dfd451a45e0161e76e3475e4e30e87e1cc1e9839509aa7c3ba42b5dd",
                "sha256:5a61379a8e62960bb62dda930787c7050ff63f195437879bccf9c4c28cdb1291",
                "sha256:b5fb418b14f96644594140b4252500fc07425fc7fd5bb9e3cd50ddb6bd3afbd8",
                "sha256:42f827e1a3dded30512b90e3c9a8f8163cabff70a724c4bfa8c79262605cef11",
                "sha256:04b9998735689e24846c57fb5103af52cbebcbe30a0e86bb4457fb980aad39f1",
                "sha256:60863b4a1d35106e2f1eb938a3ce2a895a8e252fadb38b50211d6619cb81c7d6",
                "sha256:aee815dec61e21b5133837d35ac769c9d3cc1a34d04de50ee13c362abf1c0486",
                "sha256:2bab4f9da3e7b9c7ee7000c6aed373bc45b90b4f16eb58c6ffbc2743e9416b46",
                "sha256:c11406ec15d4ad731f734d44863f20915cb373c465a67fa50342f2ea37737e3d",
                "sha256:dfcc6ab2bd0706f88a044072c94204f4a821afca5109d1195b45d61b2ac4a0d0",
                "sha256:4a90843d8f4555c71f9c63f190b3065b082541cc6912d14faf72e046bbe903ff",
                "sha256:4d016378c3c1bba1d3f01f2bb2267b4676fc6168e9c8c47585aec32ac043787e",
                "sha256:f1bd73eaefb0e56fb97382339ffa4d1318210bfc93b0cb04cae8b9c30643993a",
                "sha256:19412a66aaee7b66ea7f49ae2a691afceec0e342a0aa89c9771b8e56ca67773a"
            ]
        },

```

查看 `RootFS` 字段可以看到jenkins镜像包含了20层，Docker 把这些rootfs联合挂载在一个统一的挂载点上

- **LowerDir** 为只读镜像层。可以有多层，可以看到上面的 jenkins 镜像的 `LowerDir` 一共有19层。
- **WorkDir** 为工作基础目录，和 `Upper` 层并列， 充当一个中间层的作用，在对 `Upper` 层里面的副本进行修改时，会先到 `WorkDir`，然后再从 `WorkDir` 移动 `Upper` 层。
- **UpperDir** 为可读写层，对容器的更改发生在这一层，包含了对容器的更改，挂载方式为rw，即 read write，采用写时复制（copy-on-write）机制。
- **MergedDir** 为 `WorkDir`、`UpperDir` 和 `LowerDir` 的联合挂载点，是呈现给用户的统一视图

`/var/lib/docker/image/overlay2/layerdb` 存的只是元数据，每层真实的rootfs在`/var/lib/docker/overlay2/` 目录下，我们需要找到它的cache-id。

查看`/var/lib/docker/image/overlay2/layerdb/sha256/7948c3e5790c6df89fe48041fabd8f1c576d4bb7c869183e03b9e3873a5f33d9/cache-id`的值:

```shell
$ cat cache-id
4d335a15bbfe5484698feba460f84b8635191cb4c30f5048ae4d23c2b7fa64fe

```

`/var/lib/docker/overlay2/4d335a15bbfe5484698feba460f84b8635191cb4c30f5048ae4d23c2b7fa64fe` 就是当前层的rootfs。

进入里面可以看到一个完整的系统目录：

```shell
$ cd /var/lib/docker/overlay2/4d335a15bbfe5484698feba460f84b8635191cb4c30f5048ae4d23c2b7fa64fe
$ ls diff/
bin  boot  dev  etc  home  lib  lib64  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var

```

你在 `/var/lib/docker/overlay2/` 目录下可能会看到以“-init”结尾的目录，它对应docker的Init 层，位于只读层和读写层之间，专门用来存放 /etc/hosts、/etc/resolv.conf 等信息。在启动容器时写入的一些指定参数（每台机器环境不一样，比如hostname等）通过这一层进行修改，这些修改往往只对当前容器生效，在 `docker commit` 提交为镜像时不会将init层提交。

## Docker数据卷

默认情况下，在容器内创建的所有文件都存储在可读写容器层，可能会出现以下问题：

- 当容器被删除时，数据不会持久存在，也会跟着被删除。
- 如果其它容器进程需要此容器的数据，从容器中取数据可能会很困难。
- 容器的可读写层与容器运行的宿主机紧密耦合，不方便将数据迁移到其他地方。
- 相比直接写入主机文件系统，在可读写容器层进行文件管理可能会降低性能。

Linux系统中，Docker主要提供了3种方式用于容器的文件存储：`volumes`、 `bind mounts` 和 `tmpfs`![img](https://s2.loli.net/2025/02/25/nGEXFgyvLlwozhB.png)

- **Volume**（数据卷）存储在主机文件系统，由Docker管理，Linux下目录为`/var/lib/docker/volumes/`。非docker进程不会修改这个目录。Volume是进行Docker数据持久化的最好方法。
- **Bind mounts**可以存储在主机系统的任何位置，甚至可能是重要的系统文件或目录。Docker宿主机上的非Docker进程或Docker容器可以随时修改它们。
- **`tmpfs`**挂载只存储在宿主机的内存中，不会写入宿主机的文件系统。

我们一般使用Volume机制来进行目录挂载，docker中使用 `-v` 参数，比如启动jenkins容器时，挂载 `/var/jenkins_home` 目录：

```shell
$ docker run --name=jenkins -d -p 8080:8080 -p 50000:50000 -v jenkins_test:/var/jenkins_home jenkins/jenkins
```

其中，jenkins_test是使用`docker volume create jenkins_test` 命令创建的数据卷。

目录挂载的语法格式如下：

```shell
$ docker run -v /var/test:/home ...
```

实现将宿主机目录`/var/test` 挂载到容器的 `/home` 目录，在该挂载点 `/home` 上进行的任何操作，只是发生在被挂载的目录`/var/test` 上，而原挂载点的内容则会被隐藏起来且不受影响，不会影响容器镜像的内容。

此外，使用 `docker commit` 命令提交时，不会将宿主机目录提交，这是由于 Mount Namespace 的隔离作用，宿主机并不知道这个绑定挂载的存在。所以，在宿主机看来，容器中可读写层的 `/home` 目录始终是空的。但是，新产生的镜像里会多出来一个空的 `/home` 目录。
