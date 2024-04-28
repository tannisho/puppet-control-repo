#!/bin/bash
LUKS_DEV=`blkid | grep crypto_LUKS | /usr/bin/awk -F":" '{print $1}'`

if [ ! -z "$LUKS_DEV" ]; then
  echo $LUKS_DEV
else
  echo "None"
fi
