#!/bin/sh
set -xe

confd -onetime -backend env

cd /opt/logcabin/

exec node app

