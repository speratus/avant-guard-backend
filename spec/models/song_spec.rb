require 'rails_helper'

RSpec.describe Song, type: :model do
  context 'via associations' do
    it 'has many games' do
      song = Song.new

      4.times do
        song.games.build
      end

      expect(song.games.length).to eq(4)
    end
  end
end
