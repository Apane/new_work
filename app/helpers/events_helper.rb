module EventsHelper
  def link_to_event_owner(user)
    if user == current_user
      link_to 'You',  welcome_path
    else
      link_to user.short_name,  profile_path(user)
    end
  end

  def attend_to_event(event)
    unless event.owner_is?(current_user)
      if event.participants.include?(current_user)
        button_to 'Stop attending this event', stop_attend_event_path(event), method: :delete, remote: true,
            confirm: 'Are you sure you want to stop attending this event?',
            class: 'btn btn-warning pull-right'
      elsif event.participants.size >= event.max_attendees
        'no more places in this event'
      else
        button_to 'Attend this event', attend_event_path(event), method: :post, remote: true,
            confirm: 'Are you sure you want to RSVP for this event?',
            class: 'btn btn-warning pull-right'
      end
    end
  end
end
