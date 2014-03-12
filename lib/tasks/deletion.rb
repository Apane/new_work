namespace :deletion do
  desc :weekly_delete => :environment do
    set :output, "#{path}/log/cron.log"
    job_type :script, "'#{path}/script/:task' :output"

    every :sunday, at: "3:00 AM" do
    runner "Event.clear_expired"
    runner "Activity.clear_expired"
  end
 end
end
