#!/bin/bash
SYNC_DIR="/var/www/html/gmwork/"
LOGFILE="/var/www/html/krishna/logs/autotest_run_count.txt"
LOGFILE1="/var/www/html/krishna/logs/99bkpsync.log"
SIZE=$(du -csh $SYNC_DIR | awk '{if(NR==1) print $1}')

echo -e "Hello, \n\n99 server sync details are as below:\nSync dir= $SYNC_DIR\nSIZE of backup= $SIZE \n\nThanks and Regards,\nTeam Itsupport"  > $LOGFILE1

trap "echo manual abort; exit 1"  1 2 3 15
RUNS=0
while [ 1 ] ; do
    HOUR="$(date +'%H')"
    if [ $HOUR -ge 1 -a $HOUR -lt 6 ] ; then #do it's job between 10PM and 7AM
        # run program
        aws s3 sync $SYNC_DIR --region=us-east-1 s3://98backup/99_server_bkp$SYNC_DIR
        RUNS=$((RUNS+9))
        echo $RUNS > $LOGFILE
    else
        echo $RUNS, waiting H=$HOUR > $LOGFILE
        # note: calculating the time till next wakeup would be more 
        # efficient, but would not work when the time changes abruptly
        # e.g. a laptop is suspended and resumed
        # so, waiting a minute is reasonably efficient and robust
        sleep 60
    fi
done


