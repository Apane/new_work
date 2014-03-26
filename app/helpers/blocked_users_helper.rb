module BlockedUsersHelper
  def add_to_blocked_users
    unless current_user == @user
      if @user.blocked_for?(current_user)
        link_to 'Un-block', toggle_blocked_path(blocked_user_id: @user.id, action_type: 'unblock'), remote: true,
          class: 'col-xs-12 col-md-12 btn btn-primary block-u block-icon block_user_button'
          # confirm: 'Are you sure you want to remove this person from your favorites?'
      else
        link_to 'Block User', toggle_blocked_path(blocked_user_id: @user.id, action_type: 'block'), remote: true,
          class: 'col-xs-12 col-md-12 btn btn-primary block-u block-icon block_user_button'
          # confirm: 'Are you sure you want to add this person to your favorites?'
      end
    end
  end
end
