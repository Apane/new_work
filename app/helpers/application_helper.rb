module ApplicationHelper

  def background_image_class
    case params[:fbooktarget]
      when "m"
        "guys"
      when "f"
        "girls"
      else
        "neutral"
    end
  end

  def logo
    image_tag("friendiose_logo.png")
  end

  def logo2
    link_to image_tag("logo_2.png"), root_path
  end

  def icon(name)
    #icon("camera-retro")
    #<i class="icon-camera-retro"></i>
    html = "<i class='#{name}' "
    html += "></i>"
    html.html_safe
  end

  def class_active(key)
    if controller_name == key
      return "class='active'".html_safe
    end
  end

  def lorem
 "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, who"
  end

  def whitespace
  end

  def body_class_name
    if controller_name == 'sessions' && action_name == 'new'
      'backgroud-img'
    elsif controller_name == 'registrations' && action_name == 'new'
      'backgroud-img'
    else
      ''
    end
  end

  def container_class_name
    if controller_name == 'sessions' && action_name == 'new'
      'sign-up-bg'
    elsif controller_name == 'registrations' && action_name == 'new'
      'sign-up-bg'
    else
      ''
    end
  end
end
