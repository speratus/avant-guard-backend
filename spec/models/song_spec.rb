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

    it 'has many song_genres' do
      song = Song.new

      5.times do
        song.song_genres.build
      end

      expect(song.song_genres.length).to eq 5
    end

    it 'has many genres' do
      song = Song.new

      3.times do
        song.genres.build
      end

      expect(song.genres.length).to eq 3
    end
  end
end
