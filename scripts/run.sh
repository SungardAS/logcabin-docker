#!/bin/sh
set -xe

confd -onetime -backend env

exec collectd -f

