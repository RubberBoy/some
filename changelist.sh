#!/bin/sh

#set -e
#set -x

exptime=$(date +%m%d%H%M);

#获取当前最新版本
curHead=`svn log -r HEAD -q | grep -v '\----' | awk '{print $1}' | sed 's/r//'`;

#上次比对版本
read -r lastHead < lasthead.log;
echo "上次比对版本：" $lastHead;
echo "最新版本：" $curHead;
logHead=$lastHead

if test $lastHead == $curHead; then
    echo "nochange"
    exit 0
else
    logHead=$(($lastHead+1))
fi

svn log -r $logHead:$curHead -q \
    |grep 'gaosheng08' \
    |awk '{print $1}' | sed 's/r//' \
    |awk '{print "svn log  -r "$1" -v -q | tail -n +4 | grep -v \"\\---\""}'\
    |bash | sort -n | uniq \
    |sed "s/   M \/4\//svn diff -r $lastHead:$curHead /" \
    > $exptime.list

echo $lastHead >> history.log
echo $curHead > lasthead.log

echo "文件列表保存至：" $exptime.list;

cat $exptime.list
