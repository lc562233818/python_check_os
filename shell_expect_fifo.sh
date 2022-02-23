#!/bin/bash
#表示当前执行文件PID
tempfifo=$$.fifo
创建管道文件
mkfifo $tempfifo
并且与文件描述符10绑定
exec 10<>$tempfifo
rm -rf $tempfifo
num=`cat ip.txt | wc -l`
n=0
user=root
hostname=test
password=123456
#对文件描述符10进行写入操作，并且控制后台并发数量
for ((i=1;i<=10;i++));do
    echo >&10
done
while read ip;
do
   #读取管道内容。并创建进程在后台执行
    read -u 10
    {
    let n+=1
    /usr/bin/expect<<-END
    spawn ssh $user@$ip
    expect {
        "yes/no"  {send "yes\r"; exp_continue}
        "*assword:" {send "$password\r"}
    }
    expect "root@" {send "echo hello world$n\r"}
    expect eof
END
   #echo $?
  #写入空行，保持管道容量不变，否则可能出现阻塞
   echo >&10
}&#置于后台
done < ip1.txt
#等待所有子进程都退出，然后关闭文件描述符再推出
wait
echo "done"
exec 10>&-
exec 10<&-
exit 0
