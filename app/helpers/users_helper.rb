module UsersHelper
  def user_birthday
    if current_user.age.present?
      link_to(current_user.age, edit_account_path)
    else
      link_to('Add Birthday', edit_account_path)
    end
  end

  def user_avatar(user)
    if user.profile_photo.present?
      html = link_to (image_tag user.profile_photo.file.thumb.url), edit_account_path
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
    if user.profile_photo.present?
      html = link_to (image_tag user.profile_photo.file.small.url, class: 'img-polaroid', size: '50x50'), profile_path(user)
    else
      html = link_to (image_tag "profile-placeholder1.png", size: '50x50'), profile_path(user)
    end
    return html
  end

  def avatar(user)
    if user.profile_photo.present?
      html = image_tag user.profile_photo.file.small.url, class: 'media-object', size: '68x68'
    else
      html = image_tag "people_image.jpg", class: 'media-object', size: '68x68'
    end
    return html
  end

  def all_user_avatar(user)
    if user.profile_photo.present?
      html = link_to (image_tag user.profile_image_url(:all).to_s), user
    else
      html = link_to (image_tag "profile-placeholder1.png", size: '50x50'), user
    end
    return html
  end

  def check_connection(provider)
    (provider == 'GPlus') ? (provider_name = 'Google+') : (provider_name = provider)
    if current_user.has_connection_with(provider)
      link_to disconnect_path(social: provider.downcase) do
        content_tag :div, class: "verified-m #{provider.downcase}-verified row" do
          (content_tag :p, provider_name) +
          (content_tag :span, 'Verified', class: "verified")
        end
      end
    else
      link_to user_omniauth_authorize_path(provider: provider.downcase) do
        content_tag :div, class: "verified-m #{provider.downcase}-verified row" do
          (content_tag :p, provider_name) +
          (content_tag :span, 'Click to verify', class: "un-verified")
        end
      end
    end
  end

  def social_connection(provider, user)
    (provider == 'GPlus') ? (provider_name = 'Google+') : (provider_name = provider)
    if user.has_connection_with(provider)
      content_tag :div, class: "verified-m #{provider.downcase}-verified row" do
        (content_tag :p, provider_name) +
        (content_tag :span, user.connections_count(provider)) +
        has_connections_count?(user, provider)
      end
    else
     nil
      end
    end
  end

  def has_connections_count?(user, provider)
    if user.connections_count(provider)
      ''
    else
      (content_tag :span, 'Verified', class: "verified")
    end
  end

  def user_verifications
    if (controller_name == 'home' && action_name == 'welcome')
      render 'users/verifications'
    elsif (controller_name == 'profiles' && action_name == 'show')
      render 'profiles/verifications'
    end
  end
end
