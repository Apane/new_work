module ActivitiesHelper

  def attend_to_activity(activity)
    # use event.max_attendees + 1 as user who created event is a participant too
    if activity.is_private? && activity.user != current_user
      'This is private activity. You need an invitation to join to this activity.'
    else
      # max_attendees = activity.max_attendees.present? ? (activity.max_attendees + 1) : 100

      unless activity.owner_is?(current_user)
        if activity.participants.include?(current_user)
          button_to 'Not Interested', stop_attend_activity_path(activity), method: :delete, remote: true,
              class: 'btn btn-primary btn-lg btn-block creat-event margin-b'
        # elsif event.participants.size >= max_attendees
        #   'this activity is full'
        else
          button_to "I'm Interested", attend_activity_path(activity), method: :post, remote: true,
              class: 'btn btn-primary btn-lg btn-block creat-event margin-b'
        end
      end
    end
  end
end
