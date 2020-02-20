require 'rails_helper'

RSpec.describe Genre, type: :model do
  context 'via associations' do
    it 'has many song_genres' do
      genre = Genre.new

      4.times do
        genre.song_genres.build
      end

      expect(genre.song_genres.length).to eq 4
    end

    it 'has many songs' do
      genre = Genre.new

      5.times do
        genre.songs.build
      end

      expect(genre.songs.length).to eq 5
    end
  end
end
