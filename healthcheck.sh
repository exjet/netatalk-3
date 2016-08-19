#!/bin/bash

mkdir -p /tmp/afptest
mount_afp afp://testuser:some_password@localhost/Test_Share /tmp/afptest
umount /tmp/afptest
exit 0

