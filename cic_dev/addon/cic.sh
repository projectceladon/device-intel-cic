#!/bin/bash

snd_load=`lsmod | grep -i snd_dummy`

if [[ -z $snd_load ]]; then
  /sbin/modprobe snd-dummy
fi

/bin/bash aic $1
