#!/bin/bash
# ------------------------------------------------------------------------------
# NOTE: This file is managed by Puppet.  Do not edit it on the server.
# ------------------------------------------------------------------------------
# Safely deploy r10k with correct group ownership (saves time from `chown -R`)
# ------------------------------------------------------------------------------

R10KW="/usr/share/simp/bin/r10k"
R10KWD="$R10KW deploy environment -v info --puppetfile"
PCD='/etc/puppetlabs/code/environments'
ENV2D=$1

if [ -z $1 ] ; then
  $R10KW
  exit;
fi

#( umask 0007 && sg puppet -c "puppet generate types --environment development --debug" )
( umask 0007 && sg puppet -c "$R10KWD $ENV2D" ) # run w/proper umask in subshell

if [ $UID == 0 ]; then
  chcon -R --reference="$PCD" "$PCD/$1"           # correct SELinux contexts
fi

if [ $? == '1' ] ; then
  echo 'Exiting, please use valid environment name.'
  exit;
fi
