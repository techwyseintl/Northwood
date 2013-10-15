#!/bin/sh

echo ''
echo ''
echo '-----------------------------------------------------------------'
echo 'Date:'
date

echo 'Moving to the directory'

cd /web/northwoodmortgage.com_production/current

echo ''
echo 'Running contact reminders task'

/usr/local/bin/rake northwood_operations:send_contact_reminders RAILS_ENV=production LIVE=true

echo ''
echo 'Running job candidate followup task'
/usr/local/bin/rake northwood_operations:send_job_candidate_follow_up_emails RAILS_ENV=production


echo ''
echo 'Running newsletter sending task'

/usr/local/bin/rake northwood:send_newsletters LIVE=true RAILS_ENV=production_emailer


echo ''
echo 'DONE'