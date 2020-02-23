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

  context 'validates' do
    it 'successfully when has valid attributes' do
      a = Artist.new
      song = a.songs.build(title: 'hello world', release_date: '2020 02 13')
      song.genres.build(name: 'hyper-pop')

      expect(song.save).to eq true
    end

    it 'unsuccessfully when it is missing a title' do
      a = Artist.new(name: 'hi')
      song = a.songs.build(release_date: '01012020')
      song.genres.build(name: 'anthem')
      
      expect(song.save).to be false
    end

    it 'unsuccessfully when it is missing a genre' do
      a = Artist.new(name: 'billy')
      song = a.songs.build(title: 'real fun', release_date: '01012020')

      expect(song.save).to be false
    end
  end
end
