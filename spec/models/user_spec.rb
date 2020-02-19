require 'rails_helper'

RSpec.describe User, type: :model do
  context 'via associations' do 
    it 'can access one ranking' do
      user = User.new

      expect(user).to respond_to(:ranking)
      ranking = Ranking.new(total_score: 100, rank: 1)
      user.ranking = ranking

      expect(user.ranking).to eq(ranking)
      expect(user.ranking.total_score).to eq 100
      expect(user.ranking.rank).to eq 1
    end
  end
end
