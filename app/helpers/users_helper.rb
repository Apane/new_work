module UsersHelper
  def user_birthday
    if current_user.age.present?
      link_to(current_user.age, edit_account_path)
    else
      link_to('Add Birthday', edit_account_path)
    end
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

  def simple_user_avatar(user)
    if user.profile_image.present?
      html = link_to (image_tag user.profile_image_url(:small).to_s, class: 'img-polaroid', size: '50x50'), profile_path(user)
    else
      html = link_to (image_tag "profile-placeholder1.png", size: '50x50'), profile_path(user)
    end
    return html
  end

  def avatar(user)
    if user.profile_image.present?
      html = image_tag user.profile_image_url(:small).to_s, class: 'media-object', size: '68x68'
    else
      html = image_tag "people_image.jpg", class: 'media-object', size: '68x68'
    end
    return html
  end

  def all_user_avatar(user)
    if user.profile_image.present?
      html = link_to (image_tag user.profile_image_url(:all).to_s), user
    else
      html = link_to (image_tag "profile-placeholder1.png", size: '50x50'), user
    end
    return html
  end

  def check_connection(provider)
    if current_user.has_connection_with(provider)
      link_to disconnect_path(social: provider.downcase) do
        content_tag :div, class: "verified-m #{provider.downcase}-verified row" do
          (content_tag :p, provider) +
          (content_tag :span, 'Verified', class: "verified")
        end
      end
    else
      link_to user_omniauth_authorize_path(provider: provider.downcase) do
        content_tag :div, class: "verified-m phone-verified row" do
          (content_tag :p, provider) +
          (content_tag :span, 'Click to verify', class: "un-verified")
        end
      end
    end
  end
end
