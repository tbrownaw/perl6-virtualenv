#!/bin/bash

set -e
set -x

env >initial.env

test ! -e env 
./pl6-virt env
test -d env
test -f env/bin/activate

env >setup.env
cmp initial.env setup.env || diff initial.env setup.env

. env/bin/activate

env >active.env

deactivate

env >deactivated.env
cmp setup.env deactivated.env || diff setup.env deactivated.env

. env/bin/activate
NUM_BEFORE=$(find env | wc -l)
(! zef list --installed | grep -q YAMLish)
zef install YAMLish
NUM_AFTER=$(find env | wc -l)

test $NUM_AFTER -gt $NUM_BEFORE

zef list --installed | grep -q YAMLish

(! zef list --installed | grep -q epoll)
/bin/bash -c 'zef install epoll'
zef list --installed | grep -q epoll

deactivate
(! zef list --installed | grep -q YAMLish)
(! zef list --installed | grep -q epoll)

rm -f active.env deactivated.env setup.env initial.env
rm -rf env/
