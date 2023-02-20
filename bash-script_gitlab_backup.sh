#!/bin/bash

backup_output="/tmp/backup.output"
backup_dir="/var/opt/gitlab/backups"
max_size=100000
mail_message="Yedek alinamadi"

sudo gitlab-backup create STRATEGY=copy > $backup_output

done=`tail -1 $backup_output`

if [ -z $done="Backup task is done." ]; then
    backupfile=`cat $backup_output | grep gitlab_backup.tar | cut -f 2 -d: | cut -f 2 -d " "`
    backup_path=$backup_dir/$backupfile
    if [ -f $backup_path ]; then
        filesize=$(stat -c%s "$backup_path")
        if [ $filesize > $max_size ]; then
            mail_message="GitLAB yedekleme islemi gerceklesti, $(date +%d\ de\ %B\ %Y\ %H:%M), tarihli yedek alındı."
        else
            mail_message="Yedek dosyasi olusturalamadi.$(date +%d\ de\ %B\ %Y\ %H:%M)"
        fi
    else
        mail_message="Yedek dosyasi $backup_path de bulunamadi.$(date +%d\ de\ %B\ %Y\ %H:%M)"
    fi
else
    mail_message="Yedek tamamlanamadi.$(date +%d\ de\ %B\ %Y\ %H:%M)"
fi
echo $mail_message
echo $mail_message | mailx  \
-r "gitlab@domain.com" \
-s "GitLAB yedek islemi gerceklesti" \
-S smtp="mail.domain.com:25" \
-S smtp-use-starttls \
-S smtp-auth=login \
-S smtp-auth-user="gitlab@domain.com" \
-S smtp-auth-password="_CUgNRo2:1Td" \
-S ssl-verify=ignore \
yektakbas@gmail.com

