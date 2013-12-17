class Message < ActiveRecord::Base
  attr_accessible :body, :sender_id, :receiver_id, :opened, :opened_at

  belongs_to :sender, class_name: 'User', foreign_key: :sender_id
  belongs_to :receiver, class_name: 'User', foreign_key: :receiver_id

  # scope :deleted_for_sender, -> { where(deleted_for_sender: true) }
  # scope :deleted_for_receiver, -> { where(deleted_for_receiver: true) }
  # scope :active_for_sender, -> { where(deleted_for_sender: false) }
  # scope :active_for_receiver, -> { where(deleted_for_receiver: false) }
  scope :not_opened, -> {where(opened: false)}

  validates :body, :sender_id, :receiver_id, :presence => true

  def type_of_sent?(user)
    if self.sender == user
      true
    end
  end

  def type_of_received?(user)
    if self.receiver == user
      true
    end
  end

  def new?
    unless self.opened?
      true
    end
  end
end
