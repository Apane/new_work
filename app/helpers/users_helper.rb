module UsersHelper
  def user_birthday
    if current_user.birthday.present?
      today = Date.today
      d = Date.new(today.year, current_user.birthday.month, current_user.birthday.day)
      age = d.year - current_user.birthday.year - (d > today ? 1 : 0)
      link_to(age, edit_account_path)
    else
      link_to('Add Birthday', edit_account_path)
    end
    #best_in_place current_user, :birthday, {:type => :date, :inner_class => 'birthday',
    #                            :display_as => :format_date, :data => {'date-format' => 'yyyy-mm-dd'}}
  end

  def user_avatar(user)
    if user.profile_image.present?
      html = link_to (image_tag user.profile_image_url(:thumb).to_s), edit_account_path
    else
      link = link_to (image_tag "profile-placeholder1.png"), edit_account_path
      span = content_tag :span, class: "upload" do
              content_tag :span, class: 'btn btn-success' do
                link_to "Upload a photo", edit_account_path
              end
            end
      html = link + span
    end
    return html
  end
end
