module ConversationsHelper
  def companion
    author = @conversation.author
    companion = @conversation.companion
    (current_user == author) ? companion : author
  end
end
