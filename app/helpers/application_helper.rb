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

  def container_class_name
    if action_name == 'landing'
      @class = ''
    elsif controller_name == 'sessions'
      @class = ''
    elsif controller_name == 'registrations'
      if action_name == 'edit'
        @class = 'container'
      else
        @class = ''
      end
    else
      @class = 'container'
    end
  end
end
