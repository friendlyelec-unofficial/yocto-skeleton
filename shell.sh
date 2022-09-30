#!/usr/bin/env bash

# set -exu

# where this .sh file lives
DIRNAME=$(dirname "$0")
SCRIPT_DIR=$(cd "$DIRNAME" || exit; pwd)

cd "$SCRIPT_DIR" || exit

DEFAULT_SHELL="zsh --login"
ARGV=$*
ARGS="${ARGV:=$DEFAULT_SHELL}"

# yocto dir on host - mapped to /opt/yocto in container
DEFAULT_YOCTO_DIR="$SCRIPT_DIR/yocto/"
YOCTO_DIR="${YOCTO_DIR:=$DEFAULT_YOCTO_DIR}"
YOCTO_DIR_DIRNAME=$(dirname $YOCTO_DIR)
YOCTO_DIR_BASENAME=$(basename $YOCTO_DIR)
YOCTO_DIR_FULLPATH=$(printf "%s/%s" "$YOCTO_DIR_DIRNAME" "$YOCTO_DIR_BASENAME")
YOCTO_DIR=$(cd "$YOCTO_DIR_FULLPATH" || exit; pwd)

# pockuser homedir on host - so we can modify .bashrc and save .bash_history
DEFAULT_POKYUSER_HOME="$SCRIPT_DIR/tools/pokyuser/"
POKYUSER_HOME="${POKYUSER_HOME:=$DEFAULT_POKYUSER_HOME}"
POKYUSER_HOME_DIRNAME=$(dirname $POKYUSER_HOME)
POKYUSER_HOME_BASENAME=$(basename $POKYUSER_HOME)
POKYUSER_HOME_FULLPATH=$(printf "%s/%s" "$POKYUSER_HOME_DIRNAME" "$POKYUSER_HOME_BASENAME")
POKYUSER_HOME=$(cd "$POKYUSER_HOME_FULLPATH" || exit; pwd)

if [ "$YOCTO_DIR" = "$DEFAULT_YOCTO_DIR" ]
then
  mkdir -p "$YOCTO_DIR"
fi

if [ "$POKYUSER_HOME" = "$DEFAULT_POKYUSER_HOME" ]
then
  mkdir -p "$POKYUSER_HOME"
fi

if [[ $SHELL == *"bash"* ]]
then
  touch "$POKYUSER_HOME/.bash_history"
fi

run () {
  docker run --rm -it \
    --volume "$POKYUSER_HOME:/home/pokyuser:rw" \
    --volume "$YOCTO_DIR:/opt/yocto:rw" \
    ghcr.io/yocto-wrt/poky-extended:main "$@"
}

run bash -c "cd /opt/yocto; exec $ARGS"
