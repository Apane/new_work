module FavoritesHelper
   def add_to_favorites(fav)
    # use event.max_attendees + 1 as user who created event is a participant too
          button_to 'Mark as Favorite', add_favorite_user_path(fav), method: :post, remote: true,
              confirm: 'Are you sure you want to add this person to your favorites?',
              class: 'btn btn-primary btn-lg btn-block mark-f mark-icon'
  end
end
