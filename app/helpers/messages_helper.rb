module MessagesHelper
  def message_receiver(conversation)
    if conversation.author == current_user
      return conversation.companion.id
    elsif conversation.author != current_user
      return conversation.author.id
    end
  end

  def new_message_dot(message)
    if message.sender == current_user
      html = ''
    else
      message.new? ? html = '<span class="blue_dot pull-left"></span>'.html_safe : ''
    end
    return html
  end
end
