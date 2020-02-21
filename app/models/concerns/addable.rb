module Addable

    def save_info(track_info)
        track = track_info['track']
        track_name = track['name']
        artist_name = track['artist']['name']
        album_title = track['album']['title']
        release_date = track['wiki']['published']

        genres = track['toptags']['tag'].map do |tag|
            Genre.find_or_create_by(name: tag['name'])
        end

        artist = Artist.find_or_create_by(name: artist_name)

        song = Song.new(
            title: track_name, 
            album: album_title,
            release_date: release_date.split('')[2],
            artist: artist
        )

        genres.each |g| {song.genres << g}
        song.save
        artist.save
        song
    end
end