echo ''
echo 'Sending shared files notification'

/usr/local/bin/rake northwood:send_shared_files_notification LIVE=true RAILS_ENV=production_emailer

echo ''
echo 'DONE'