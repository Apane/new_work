class Conversation < ActiveRecord::Base
  attr_accessible :author_id, :companion_id

  has_many :messages, dependent: :destroy
  has_many :new_messages, -> { where is_new: true }, class_name: 'Message'
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  belongs_to :companion, class_name: 'User', foreign_key: 'companion_id'
  has_many :reports, as: :reportable

  def mark_as_unread(user)
    self.messages.where(recipient_id: user.id).last.update_attributes(is_new: true)
  end

  def self.act_on_conversations(conversations, action, current_user, users)
    conversations.map{|c| c.destroy} if action == 'delete'
    conversations.map{|c| c.mark_as_unread(current_user)} if action == 'unread'
    if action == 'block_users'
      users = User.where(id: users[:user_ids].split('').uniq)
      users.map{|user| current_user.block(user)}
    else
      p "Uknown action"
    end
  end
end
