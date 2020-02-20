require 'rails_helper'

RSpec.describe GenreScore, type: :model do
  context 'via associations' do
    it 'belongs to a user' do 
      user = User.new

      genre_score = user.genre_scores.build

      expect(genre_score.user).to eq(user)
    end
  end
end
