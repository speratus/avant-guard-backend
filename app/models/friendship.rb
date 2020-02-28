class Friendship < ApplicationRecord
  belongs_to :friender, class_name: 'User'
  belongs_to :friended, class_name: 'User'

  validates :friender, :friended, presence: true
  validate :friender_and_friend_are_not_identical
  validate :friendship_does_not_exist

  check_perm 'friendships#create' do |friendship, user|
    friendship.friender == user
  end

  check_perm 'friendships#destroy' do |friendship, user|
    friendship.friender == user || friendship.friended == user
  end

  def friender_and_friend_are_not_identical
    if self.friender == self.friended
      errors[:friender] << 'Friender must not be friended user'
      errors[:friended] << 'Friended must not be friending user'
    end
  end

  def friendship_does_not_exist
    possible_friendship = Friendship.find_by(friender_id: self.friender_id, friended_id: self.friended_id)

    if possible_friendship
      errors[:friender] << 'Already friends with that user'
      errors[:friended] << 'Already friends with that user'
    end
  end
end
