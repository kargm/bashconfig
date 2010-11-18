#!/bin/bash

# get debian version and name
DEBIAN_VERSION=$(cat /etc/debian_version | cut -b -3)
case ${DEBIAN_VERSION} in
  "3.0") export DEBIAN_NAME="woody";;
  "3.1") export DEBIAN_NAME="sarge";;
  "4.0") export DEBIAN_NAME="etch";;
  "5.0") export DEBIAN_NAME="lenny";;
  *)     export DEBIAN_NAME="ubuntu";;
esac

case ${MACHTYPE} in
  "i386-pc-linux-gnu" | "i486-pc-linux-gnu")
    export ARCHITECTURE=i486-unknown-linux2.0.0
    export ARCH_SHORT=i386;;
  "x86_64-pc-linux-gnu")
    export ARCHITECTURE=amd64-unknown-linux2.x
    export ARCH_SHORT=amd64;;
  *)
    export ARCHITECTURE=unknown
    export ARCH_SHORT=unknown
    echo "unknown MACHTYPE=${MACHTYPE}"
esac

# architecture directory
export ARCH_DIR=${DEBIAN_NAME}-${ARCH_SHORT}${ARCH_SUFFIX:+-$ARCH_SUFFIX}

# get hostname
export HOSTNAME=$(hostname)

case ${DEBIAN_VERSION} in
  "5.0") export TRUEHOME=${HOME}/..;;
  *)     export TRUEHOME=${HOME};;
esac


# Pfadvars für Docs Repo
export TEXTMFHOME=${TRUEHOME}/../../../work/kargm/docs/trunk/texmf
export BIBINPUTS=${TRUEHOME}/../../../work/kargm/docs/trunk/bibliography:

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
fi


# read global bashrc
if [ -f /etc/bash.bashrc ]; then
  source /etc/bash.bashrc
fi

# helper fun
  parse_git_branch ()
  {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \1/'
  }

export PS1="${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[31m\]\$(parse_git_branch)\[\033[00m\]\$ "




# python version
PYTHON_VERSION=$(readlink $(which python))

# bash completion
if [ "$PS1" -a -f /etc/bash_completion ]; then
  source /etc/bash_completion
fi

# .login settings
export PATH=${PATH}:/usr/local/lehrstuhl/bin/${ARCHITECTURE}:/usr/local/lehrstuhl/bin
export MANPATH=/usr/local/man:/usr/man:/usr/share/man:/usr/local/lehrstuhl/man:${MANPATH}

# own settings
export JAVA_HOME=/usr/local/lehrstuhl/DIR/javaforlinux/${ARCHITECTURE}/jdk1.5.0
export CLASSPATH=${JAVA_HOME}/lib/tools.jar:${JAVA_HOME}/jre/lib/rt.jar:/usr/local/lehrstuhl/DIR/javaforlinux/libraries/weka_fipm.jar:.:
export PATH=${JAVA_HOME}/bin:${PATH}
export MANPATH=${JAVA_HOME}/man:${MANPATH}

# moesenle path
export MOESENLE_HOME=/usr/wiss/moesenle
export PATH=${MOESENLE_HOME}/local/public/all/bin:${MOESENLE_HOME}/local/public/${ARCH_DIR}/bin:${PATH}
export LD_LIBRARY_PATH=${MOESENLE_HOME}/local/public/all/lib:${MOESENLE_HOME}/local/public/${ARCH_DIR}/lib:${LD_LIBRARY_PATH}
export MANPATH=${MOESENLE_HOME}/local/public/all/share/man:${MOESENLE_HOME}/local/public/${ARCH_DIR}/share/man:${MANPATH}
export PYTHONPATH=${MOESENLE_HOME}/local/public/${ARCH_DIR}/lib/${PYTHON_VERSION}/site-packages:${PYTHONPATH}
export PERL5LIB=${MOESENLE_HOME}/local/public/${ARCH_DIR}/lib/perl//5.8.8:${PERL5LIB}
export PKG_CONFIG_PATH=${MOESENLE_HOME}/local/public/${ARCH_DIR}/lib/pkgconfig:${PKG_CONFIG_PATH}
export CPATH=${MOESENLE_HOME}/local/public/${ARCH_DIR}/include:${CPATH}
export LDFLAGS="-L${MOESENLE_HOME}/local/public/${ARCH_DIR}/lib"

# private path
export PATH=${TRUEHOME}/local/all/bin:${TRUEHOME}/local/${ARCH_DIR}/bin:${TRUEHOME}/local/${ARCH_DIR}/bin:${PATH}
export LD_LIBRARY_PATH=${TRUEHOME}/local/all/lib:${TRUEHOME}/local/${ARCH_DIR}/lib:${LD_LIBRARY_PATH}
export MANPATH=${TRUEHOME}/local/all/man:${TRUEHOME}/local/${ARCH_DIR}/man:${MANPATH}
export PYTHONPATH=${TRUEHOME}/local/${ARCH_DIR}/lib/${PYTHON_VERSION}/site-packages:${PYTHONPATH}
export PERL5LIB=${TRUEHOME}/local/${ARCH_DIR}/lib/perl//5.8.8:${PERL5LIB}
export PKG_CONFIG_PATH=${TRUEHOME}/local/all/lib/pkgconfig:${TRUEHOME}/local/${ARCH_DIR}/lib/pkgconfig:${PKG_CONFIG_PATH}
export CPATH=${TRUEHOME}/local/${ARCH_DIR}/include:${CPATH}
export LDFLAGS="-L${TRUEHOME}/local/all/lib -L${TRUEHOME}/local/${ARCH_DIR}/lib ${LDFLAGS}"
export INFOPATH=$INFOPATH:${TRUEHOME}/local/${ARCH_DIR}/share/info:${TRUEHOME}/local/all/share/info


# tab completion ignores those
export FIGNORE=.svn

##### rlwrap #####
export RLWRAP_HOME=${TRUEHOME}/.rlwrap

##### Cogito #####
export PLAYERPATH=${TRUEHOME}/work/lisp/kibo/pg-sim/lib/${ARCH_DIR}/player-plugins
export GAZEBOPATH=${TRUEHOME}/work/lisp/kibo/pg-sim/lib/${ARCH_DIR}/gazebo-plugins
if [ -z "${SSH_CLIENT}" ]; then
  export KIBO_AGENT_PLAYER_HOST="127.0.0.1"
else
  export KIBO_AGENT_PLAYER_HOST="$(echo ${SSH_CLIENT} | cut -f 1 -d " ")"
fi

######### For 32 Bit player ########
#export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MOESENLE_HOME}/local/public/lenny-i386/lib
#export LDFLAGS="-L${MOESENLE_HOME}/local/public/lenny-i386/lib ${LDFLAGS}"


##### Lisp #####
export LISP_SOFTWARE_ROOT=/usr/local/lehrstuhl/DIR/lisp
export CMUCL_ROOT=${LISP_SOFTWARE_ROOT}/implementations/cmucl-19c
export ALLEGRO_ROOT=${LISP_SOFTWARE_ROOT}/implementations/acl-8.0-${ARCH_SHORT}
export CMUCLCORE=${LISP_SOFTWARE_ROOT}/images/cmucl-19c/cmucl-rpl-${DEBIAN_NAME}.core
export ACLCORE=${LISP_SOFTWARE_ROOT}/images/acl-8.0-${ARCH_SHORT}/acl-rpl-${DEBIAN_NAME}.core

##### Lisp Wrappers #####
export LISP_BREAK_CHARS="\"#'(),;\`\\|!?[]{}"
alias cmucl='rlwrap -b ${LISP_BREAK_CHARS} cmu-lisp'
alias allegro='rlwrap -b ${LISP_BREAK_CHARS} allegro-lisp -I ${ACLCORE}'

# set aliases
test -s ${TRUEHOME}/.bashconfig/.alias && source ${TRUEHOME}/.bashconfig/.alias

export TEXMFHOME='${TRUEHOME}/.texmf:/work/kargm/docs/trunk/texmf'
export BIBINPUTS=..:/work/kargm/docs/bibliography

# get docs-ias bib and texmf
export TEXMFHOME='${TRUEHOME}/.texmf:/work/docs-ias/texmf':$TEXMFHOME
export BIBINPUTS=..:/work/docs-ias/bibliography

export EDITOR=vim

# ROS stuff
#source /opt/ros/cturtle/setup.sh
#export ROS_MASTER_URI=http://localhost:11311
#export ROBOT=sim
#export ROS_PACKAGE_PATH=${TRUEHOME}/work/ros_tutorials:$ROS_PACKAGE_PATH
#export ROS_PACKAGE_PATH=$HOME/ros/sandbox/01:$ROS_PACKAGE_PATH

#Fall school 2010
source ${TRUEHOME}/ros/setup.sh
export ROBOT=sim
#Set java version 1.6
export JAVA_HOME=/usr/lib/jvm/java-6-sun
export PATH=${JAVA_HOME}/bin:${PATH}
export ROSJAVA_AUX_CLASSPATH=`rospack find rosjava_deps`/rosjava_msgs.jar
export CLASSPATH=`rospack find rosjava_deps`/rosjava_msgs.jar

#Morse simulator
export ORS_ROOT=${TRUEHOME}/local/ubuntu-amd64/DIR/morse
export PYTHONPATH=$ORS_ROOT/lib/python2.6/site-packages:$ORS_ROOT/lib/python2.6/site-packages/morse/blender:${PYTHONPATH}

#Blender executable needed for MORSE simulator
export ORS_BLENDER=${TRUEHOME}/work/blender/blender-2.49b-linux-glibc236-py26-x86_64/blender