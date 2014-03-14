require 'date'
task :weeklydelete do
  if Date.today.wday.zero?
    runner "Event.clear_expired"
    runner "Activity.clear_expired"
  end
end
