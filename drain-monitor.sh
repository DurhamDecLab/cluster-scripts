#! /bin/bash

if [ -z "$3" ] # if no arg 3 then something is missing
	then
		echo "Insufficient args, need node, partition and email address"
else
	# send to background if not already done
	if [[ "$4" != "background" ]]; then
	    $0 $1 $2 $3 background & disown
	    exit $?
	fi
	node=$1
	partition=$2
	recipient=$3
	echo "Watching $node in $partition for drain"
	subject="$node drain watch"
	drainmail="subject:$subject\nNode $node is now drained"
	timeoutmail="subject:$subject\nNode $node drain watch timed out"

run_time=0
while true
do
	status=$(sinfo -n $node -p $partition)
	run_time=$(($run_time+600))
	# timeout
	if [ $run_time -gt 604800 ];then
		echo "Maximum run time, exiting now..."
		echo -e $timeoutmail | /usr/sbin/sendmail "$recipient"
		break
	else
		echo $status | grep -w -q drain
		if [ $? == 0 ];then
		echo "Drained, exiting..."
		echo -e $drainmail | /usr/sbin/sendmail "$recipient"
		break
		fi
		sleep 600
	fi
done
fi



