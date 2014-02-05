module FavoritesHelper
  def add_to_favorites
    unless current_user == @user
      if current_user.favorited?(@user)
        link_to 'Remove from Favorite', toggle_favorite_path(favorite_id: @user.id, action_type: 'remove'), remote: true,
          confirm: 'Are you sure you want to remove this person from your favorites?',
          class: 'btn btn-primary btn-lg btn-block mark-f mark-icon favorite_button'
      else
        link_to 'Mark as Favorite', toggle_favorite_path(favorite_id: @user.id, action_type: 'add'), remote: true,
          confirm: 'Are you sure you want to add this person to your favorites?',
          class: 'btn btn-primary btn-lg btn-block mark-f mark-icon favorite_button'
      end
    end
  end
end
