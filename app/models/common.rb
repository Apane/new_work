class Common
  # update min and max age for event and activity before save
  def self.set_min_max_age(object)
    if object.ages.present?
      ages = object.ages.split('-')
      object.age_min = ages[0]
      object.age_max = ages[1]
    end
  end

  # update time and date for event and activity before save
  def self.update_event_date(object)
    date = object.date.to_s
    time = object.time

    hour = Time.parse(time).strftime("%H:%M:%S").to_s
    event_date = (date + ' ' + hour).to_time
    if object.class.name == 'Event'
      object.event_date = event_date
    else
      object.activity_date = event_date
    end
  end
end
