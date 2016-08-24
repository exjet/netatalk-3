#!/bin/bash

mkdir -p /tmp/afptest
mount_afp afp://testuser:some_password@localhost/Test_Share /tmp/afptest
sleep 3
umount /tmp/afptest
exit 0

