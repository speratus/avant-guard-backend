require 'rails_helper'

RSpec.describe Ranking, type: :model do
  context 'via associations' do
    it 'belongs to a user' do
      ranking = Ranking.new
      user = User.new
      ranking.user = user

      expect(ranking.user).to eq(user)
    end
  end
end
