# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#SEEDING PROCEDURE
#
# 1. QUERY LASTFM TOP ARTISTS
#
# 2. SAVE ARTIST DATA
#
# 3. QUERY EACH ARTIST'S TOP SONGS
#
# 4. SAVE TOP SONG DATA
#
# 5. QUERY EACH SONG'S TOP TAGS
#
# 6. SAVE TOP TAG DATA
puts "Requiring LastFm library"
require_relative '../lib/last_fm_query'

puts "Success. Including LastFm library methods"
include LastFmQuery

puts "Assigning global values."
TOP_TRACK_NUMBER = 500
TOP_TRACK_PAGE = 1

puts "Destroying existing db entries"
Song.destroy_all
Artist.destroy_all
Genre.destroy_all


puts "Retrieving charts data"
charts = chart_get_top_tracks(TOP_TRACK_PAGE, TOP_TRACK_NUMBER)

tracks = charts['tracks']['track']

song_save_count = 0

puts "Entering detail lookup loop"
tracks.each do |t|
    puts "Extracting track artist and name"
    title = t['name']
    artist_name = t['artist']['name']

    puts "Looking up details for #{artist_name} song: #{title}"
    track_details = track_get_info(URI.encode(artist_name), URI.encode(title))['track']

    album_title = track_details['album']['title']
    puts "track found on album #{album_title}"

    puts "Locating or creating artist #{artist_name}"
    artist = Artist.new(name: artist_name)

    puts "Building song object"
    song = artist.songs.build(title: title, album: album_title, listens: track_details['playcount'].to_i)

    puts "Adding genres"
    track_details['toptags']['tag'].each do |tag|
        genre = Genre.find_or_create_by(name: tag['name'])
        song.genres << genre

        puts "saving genre #{genre}"
        genre.save
    end

    puts "Saving artist and song"
    song.save
    artist.save
    song_save_count += 1

    sleep_time = rand(1.0...2.5)
    puts "Sleeping for #{sleep_time} seconds"
    sleep(sleep_time)
end

puts "Done. Saved #{song_save_count} songs."