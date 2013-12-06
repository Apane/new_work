module UsersHelper
  def user_birthday
    # if current_user.birthday.present?
    #   today = Date.today
    #   d = Date.new(today.year, current_user.birthday.month, current_user.birthday.day)
    #   age = d.year - current_user.birthday.year - (d > today ? 1 : 0)
    # else
    #   current_user.birthday.present? ? current_user.birthday.year : link_to('Add Birthday', edit_account_path)
    # end
    best_in_place current_user, :birthday, {:type => :date, :inner_class => 'birthday',
                                :display_as => :format_date, :data => {'date-format' => 'yyyy-mm-dd'}}
  end
end
