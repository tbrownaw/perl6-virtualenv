#!/bin/bash

set -e

env >initial.env

test ! -e env 
./pl6-virt env
test -d env
test -f env/bin/activate

env >setup.env
cmp initial.env setup.env

. env/bin/activate

env >active.env

deactivate

env >deactivated.env
cmp setup.env deactivated.env

. env/bin/activate
NUM_BEFORE=$(find env | wc -l)
! zef list --installed | grep -q YAMLish
zef install YAMLish
NUM_AFTER=$(find env | wc -l)

test $NUM_AFTER -gt $NUM_BEFORE

zef list --installed | grep -q YAMLish

deactivate
! zef list --installed | grep -q YAMLish

rm -f active.env deactivated.env setup.env initial.env
rm -rf env/
