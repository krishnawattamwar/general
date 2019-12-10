#!/bin/bash
SYNC_DIR="/var/www/html/"
LOGFILE="/var/www/html/krishna/logs/autotest_run_count.txt"
LOGFILE1="/var/www/html/krishna/logs/99bkpsync.log"
SYNC_LOG="/var/www/html/krishna/logs/sync_$(date +"%Y_%m_%d-%I_%M_%p").log"
#SIZE=$(du -csh $SYNC_DIR | awk '{if(NR==1) print $1}')

#echo -e "Hello, \n\n99 server sync details are as below:\nSync dir= $SYNC_DIR\nSIZE of backup= $SIZE \n\nThanks and Regards,\nTeam Itsupport"  > $LOGFILE1

trap "echo manual abort; exit 1"  1 2 3 15
RUNS=0
while [ 1 ] ; do
    HOUR="$(date +'%H')"
        DATE="$(date)"
        #Enter Today's Time between 1-23
        if [ $HOUR -ge 21 -a $HOUR -lt 00 ] ; then #do it's job between 10PM and 7AM 
        #run program
#       echo "1hi $DATE" >> $SYNC_LOG
        aws s3 sync $SYNC_DIR --region=us-east-1 s3://98backup/99_server_bkp$SYNC_DIR >> $SYNC_LOG
#        aws s3 sync /var/www/html/ --region=us-east-1 s3://98backup/99_server_bkp/var/www/html/ >> /var/www/html/krishna/logs/sync_log.log
        RUNS=$((RUNS+9))
        echo $RUNS > $LOGFILE

                #If you wish to run script aft 00:00 then mention time below:
                elif [ $HOUR -ge 00 -a $HOUR -lt 7 ] ; then #do it's job between 10PM and 7AM
                # run program
#               echo "2hi $DATE" >> $SYNC_LOG
                aws s3 sync $SYNC_DIR --region=us-east-1 s3://98backup/99_server_bkp$SYNC_DIR  >> $SYNC_LOG
                RUNS=$((RUNS+9))
                echo $RUNS > $LOGFILE    
        else
        echo $RUNS, waiting H=$HOUR > $LOGFILE
        # note: calculating the time till next wakeup would be more 
        # efficient, but would not work when the time changes abruptly
        # e.g. a laptop is suspended and resumed
        # so, waiting a minute is reasonably efficient and robust
#       sleep 60
        fi
done

