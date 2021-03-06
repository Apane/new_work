module EventsHelper
  def link_to_event_owner(user)
    if user == current_user
      link_to 'You',  welcome_path
    else
      link_to user.username,  profile_path(user)
    end
  end

  def attend_to_event(event)
    # use event.max_attendees + 1 as user who created event is a participant too
    if event.is_private? && event.user != current_user
      'This is private event. You need an invitation to attend to this event.'
    else
      max_attendees = event.max_attendees.present? ? (event.max_attendees) : 100

      unless event.owner_is?(current_user)
        if event.participants.include?(current_user) || event.waiting_participants.include?(current_user)
          button_to 'Leave this event', stop_attend_event_path(event), method: :delete, remote: true,
              class: 'btn btn-primary btn-lg btn-block creat-event margin-b'
        else
          button_to 'Rsvp to this event', attend_event_path(event), method: :post, remote: true,
              class: 'btn btn-primary btn-lg btn-block creat-event margin-b'
        end
      end
    end
  end
end

# elsif event.participants.size >= max_attendees
# "<button class='btn btn-primary btn-lg btn-block creat-event margin-b' data-toggle='modal' data-target='.bs-example-modal-sm'>Rsvp to this event</button>".html_safe
