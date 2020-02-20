require 'rails_helper'

RSpec.describe SongGenre, type: :model do
  context 'via associations' do
    it 'belongs to a song' do
      song_genre = SongGenre.new
      song = Song.new

      expect {song_genre.song = song}.not_to raise_error

      expect(song_genre.song).to eq(song)
    end

    it 'belongs to a genre' do
      song_genre = SongGenre.new
      genre = Genre.new

      expect {song_genre.genre = genre}.not_to raise_error

      expect(song_genre.genre).to eq(genre)
    end
  end
end
