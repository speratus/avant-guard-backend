require 'rails_helper'

RSpec.describe Friendship, type: :model do
  context 'via associations' do
    it 'belongs to a friender' do
      friender = User.new
      friended = User.new

      friendship = friender.friendships.build(friended: friended)

      friendship.friender = friender
      friendship.friended = friended

      expect(friendship.friender).to eq(friender)
      expect(friendship.friended).to eq(friended)

      expect(friender.friends).to include(friended)
      # expect(friended.friendships).to include(friendship)
    end

    it 'belongs to a friended' do
      friender = User.create(name: 'name', username: 'demo', password: 'ytho')
      friended = User.create(name: 'name', username: 'demo2', password: 'bcuzy!')

      friendship = nil
      expect {friendship = friender.friendships.build(friended: friended)}.not_to raise_error
      friender.save

      expect(friended.frienders).to include(friender)
    end
  end
end
