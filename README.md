# M1 HMCL Hack

A wrapper script made for [Hello Minecraft! Launcher (HMCL)](https://github.com/huanghongxun/HMCL) to get any Minecraft versions newer than 1.7.10 running *natively* on Apple Silicon devices. Not quite accurate as its name implies, this script should also work on M2 models.

## Important notes

I have been using these libraries during my own gameplay and there has been no harm caused since. But it is still important you be aware that some of the native libraries in this repository were built by others, and it is impossible for me to verify that they are completely safe. As a result, I will not be responsible for any damage or harm caused when using this repository.

## Usage

### Step 1: Download Java and HMCL

Download and install Java JDK for the Minecraft version you are going to play. It is recommended that you download [ZULU JDK from Azul](https://www.azul.com/downloads/) for better performance. The desired architecture is `ARM 64-bit`, and the package `JDK-FX`. The version to install can be determined with the help of [the compatibility table](#compatibility).

Then download the latest `.jar` version of HMCL. The version number is 3.5.3.221 as I am writing this.

### Step 2: Clone repository

Clone this repository to your desired location.

```shell
git clone https://github.com/DotIN13/m1-hmcl-hack.git
```

### Step 3: Setup wrapper command

Run HMCL, and download or create a new instance of Minecraft.

Go to the instance setting page, click `Enable per-instance settings`, select compatible `Java Path`.

In advanced settings, set wrapper command to `/usr/bin/ruby /path/to/index.rb`, and tick `Do not check JVM compatibility` on the bottom. Beware that HMCL would run `cd /path/to/.minecraft` before launching, and thus the path to `index.rb` should either be absolute, or relative to the `.minecraft` directory.

Now hit play button! The game should be running natively.

## Compatibility

The script is developed with an M1 MacBook running macOS Monterey 12.5. The following versions of minecraft have been tested on the developing machine.

| Minecraft | Java         | LWJGL |
| --------- | ------------ | ----- |
| 1.19      | \>= 17       | 3.3.1 |
| 1.18      | \>= 17       | 3.3.1 |
| 1.17      | \>= 17       | 3.2.3 |
| 1.16      | \>= 8        | 3.2.3 |
| 1.12      | \>= 8, <= 11 | 2.9.4 |
| 1.10      | 8            | 2.9.4 |
| 1.7       | 8            | 2.9.4 |

> The LWJGL versions in the table only depict the versions used by this script. Generally, a minecraft version can work with multiple compatible LWJGL versions.

### Speed tests

Below is an intersting test with the wrapper script to compare roughly the time spent launching each version of minecraft in seconds (look the column `real` for real time elapsed).

```log
                    user     system      total        real
1.19.2:         0.000198   0.000845  71.122210 ( 11.873934)
1.18.2:         0.000925   0.000831  73.128093 ( 13.050732)
1.18.2-forge:   0.001717   0.000979  98.204459 ( 17.406919)
1.17.1-forge:   0.001620   0.000781 103.826104 ( 17.391302)
1.16.5-forge:   0.001360   0.000900  87.128180 ( 14.034758)
1.15.2-forge:   0.001338   0.001390  62.070330 ( 14.474847)
1.12.2:         0.000804   0.001058  10.736893 (  4.945872)
1.12.2-forge:   0.001549   0.000908  28.464906 ( 11.927635)
1.10.2-forge:   0.001164   0.000947  25.818846 (  8.957163)
1.7.10-forge:   0.001165   0.001362  20.039469 (  7.703704)
```

## Credits

The LWJGL 3.3.1 native libraries are downloaded directly from [the official website](https://www.lwjgl.org/customize).

The modified LWJGL 3.2.3 native libraries are built by [tanmayb123](https://gist.github.com/tanmayb123/d55b16c493326945385e815453de411a).

The modified LWJGL 2.9.4 native libraries are built by [r58Playz](https://github.com/r58Playz/m1-multimc-hack).

The idea of creating a wrapper script was first introduced by [yusefnapora](https://github.com/yusefnapora/m1-multimc-hack).

## Licensing

All the LWJGL binaries are provided under [the BSD License of the LWJGL Project](https://www.lwjgl.org/license). The code of the script is provided under the [MIT license](https://github.com/DotIN13/m1-hmcl-hack/blob/master/LICENSE).

## Related projects

[ManyMC](https://github.com/MinecraftMachina/ManyMC) claimed to have achieved zero-configuration native gaming experience on Apple Silicon devices. It has not been tested by me, but maybe it is worth a try as both r58Playz and yusefnapora have been encoraging the migration to this specific launcher.
