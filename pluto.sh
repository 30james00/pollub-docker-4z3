#!/bin/sh

DATE=$(date '+%Y-%m-%d %H-%M-%S')
echo Date ${DATE} > /logi/info.log
cat /sys/fs/cgroup/memory/memory.usage_in_bytes  | awk '{ byte =$1 /1024/1024; print "Memory usage " byte " MB" }' >> /logi/info.log