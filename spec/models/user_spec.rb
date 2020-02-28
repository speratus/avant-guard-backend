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

    it 'can access multiple games' do
      user = User.new

      5.times do
        user.games.build
      end

      expect(user.games.length).to eq 5
    end

    it 'has many genre_scores' do
      user = User.new

      6.times do
        user.genre_scores.build
      end

      expect(user.genre_scores.length).to eq 6
    end

    it 'has many friendships' do
      user = User.new

      7.times do
        user.friendships.build
      end

      expect(user.friendships.length).to eq 7
    end

    it 'has many friends' do
      user = User.new

      3.times do
        user.friends.build
      end

      expect(user.friends.length).to eq 3
    end

    # it 'has many friendedships' do
    #   friended = User.create
    #   friender = User.create

    #   friender.friendships.build(friended: friended)
    #   friender.save

    #   expect(friended.friendedships).to include(friender.friendships[0])
    # end
  end
end
