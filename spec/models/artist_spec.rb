require 'rails_helper'

RSpec.describe Artist, type: :model do
  context 'via associations' do
    it 'has many songs' do
      artist = Artist.new

      4.times do
        artist.songs.build
      end

      expect(artist.songs.length).to eq 4
    end

    it 'has many genres' do
      artist = Artist.new

      5.times do
        song = artist.songs.build(title: 'test')

        rand(1..6).times do
          g = song.genres.build(name: 'demo')
          g.save
        end

        song.save
        # puts "It has genres: #{song.genres.map {|g| g.name}}"
      end

      artist.save

      expect(artist.genres.length).to be > 5
    end

  end

  context 'validates' do
    it 'successfully if info is valid' do
      artist = Artist.new(name: 'test')
      
      expect(artist.save).to eq true
    end

    it 'unsuccessfully if info is invalid' do
      artist = Artist.new

      expect(artist.save).to eq false
    end
  end
end
