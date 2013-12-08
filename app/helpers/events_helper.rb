module EventsHelper
  def link_to_event_owner(user)
    if user == current_user
      link_to 'You',  welcome_path
    else
      link_to user.short_name,  profile_path(event.user)
    end
  end
end
