# skeleton

Baseline yocto build environment

## What is this?

A forkable repository to scaffold a yocto-wrt build.
Also acts as a demonstration

## How do I use it?

```
# on your build host
git clone --recursive https://github.com/yocto-wrt/skeleton.git
cp -r skeleton mybuild
cd mybuild
./shell.sh

# inside the builder container now
# ./yocto -> /opt/yocto by default
# ./tools/pokyuser -> /home/pokyuser by default
source layers/poky/oe-init-build-env build/qemux86-64
bitbake core-image-minimal
```

## Does it work yet?

Maybe. Probably not. Keep an eye for changes.
