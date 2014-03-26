module HiddenUsersHelper
  def add_to_hidden_users
    unless current_user == @user
      if @user.hidden_for?(current_user)
        link_to 'Un-Hide', toggle_hidden_path(hidden_user_id: @user.id, action_type: 'unhide'), remote: true,
          class: 'col-xs-12 col-md-12 btn btn-primary hide-u hide-icon hide_user_button'
          # confirm: 'Are you sure you want to remove this person from your favorites?'
      else
        link_to 'Hide User', toggle_hidden_path(hidden_user_id: @user.id, action_type: 'hide'), remote: true,
          class: 'col-xs-12 col-md-12 btn btn-primary hide-u hide-icon hide_user_button'
          # confirm: 'Are you sure you want to add this person to your favorites?'
      end
    end
  end
end
