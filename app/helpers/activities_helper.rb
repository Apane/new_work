module ActivitiesHelper

  def attend_to_activity(activity)
    # use event.max_attendees + 1 as user who created event is a participant too
    if event.is_private? && event.user != current_user
      'This is private activity. You need an invitation to join to this activity.'
    else
      max_attendees = event.max_attendees.present? ? (event.max_attendees + 1) : 100

      unless event.owner_is?(current_user)
        if event.participants.include?(current_user)
          button_to 'Leave this activity', stop_attend_event_path(event), method: :delete, remote: true,
              confirm: 'Are you sure you want to stop attending this activity?',
              class: 'btn btn-primary btn-lg btn-block creat-event margin-b'
        elsif event.participants.size >= max_attendees
          'this activity is full'
        else
          button_to "I'm Interested", attend_event_path(event), method: :post, remote: true,
              confirm: 'Are you sure you want to join this activity?',
              class: 'btn btn-primary btn-lg btn-block creat-event margin-b'
        end
      end
    end
  end
end
