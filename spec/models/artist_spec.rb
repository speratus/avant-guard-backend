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

      # puts "There are #{Genre.all.length} genres. They are #{Genre.all.map {|g| g.name}}"

      # puts "artist: #{artist}. artist songs: #{artist.songs.map {|s| s.title}}. artist genres: #{artist.genres.map {|g| g.name}}"

      # artist.songs.each do |s|
      #   puts "song #{s.title} has #{s.genres.length} genres. they are #{s.genres.map {|g| g.name}}."
      # end

      expect(artist.genres.length).to be > 5
    end
  end
end
