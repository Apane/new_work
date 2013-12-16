class Message < ActiveRecord::Base
  attr_accessible :body, :sender_id, :receiver_id

  belongs_to :sender, class_name: 'User', foreign_key: :sender_id
  belongs_to :receiver, class_name: 'User', foreign_key: :receiver_id

  scope :deleted_for_sender, -> { where(deleted_for_sender: true) }
  scope :deleted_for_receiver, -> { where(deleted_for_receiver: true) }

  validates :body, :sender_id, :receiver_id, :presence => true

  def type_of_sent?(user)
    if sender == user
      true
    end
  end

  def type_of_received?(user)
    if receiver == user
      true
    end
  end
end
