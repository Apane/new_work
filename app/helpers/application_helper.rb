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

end
