# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
# sudo service cron status
# sudo service cron stop
# sudo service cron start
# crontab -r (clean all crontab)
# update cron: whenever --update-crontab
# update cron development: whenever --update-crontab --set environment='development'

# Shows the full path to Bundler
bundle_path = "/home/hiepth/.rbenv/shims/bundle"  # use path from command "which bundle"

# config job_type for rake
job_type :rake, "cd :path && :environment_variable=:environment #{bundle_path} exec rake :task --silent :output"

# write log output
set :output, "./log/booking_reminder.log"

every 1.day, at: "8:30 am" do
  rake "booking:send_reminder_email"
end
