class Friendship < ApplicationRecord
  belongs_to :friender, class_name: 'User'
  belongs_to :friended, class_name: 'User'

  validates :friender, :friended, presence: true
  validate :friender_and_friend_are_not_identical

  def friender_and_friend_are_not_identical
    if self.friender == self.friended
      errors[:friender] << 'Friender must not be friended user'
      errors[:friended] << 'Friended must not be friending user'
    end
  end
end
