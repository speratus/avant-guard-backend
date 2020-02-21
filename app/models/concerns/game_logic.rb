require_relative '../../../last_fm_query'

module GameLogic
    include LastFmQuery

    def save_track_info(track_info)
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

    def pick_genre_from_db
        Genre.all.sample
    end

    def pick_artist_from_db
        Artist.all.sample
    end

    def select_song_from_genre(genre)
        genre.songs.sample
    end

    def select_song_from_artist(artist)
        artist.songs.sample
    end

    def pick_new_song_from_genre(genre)
        song = select_song_from_genre(genre)
        resp = track_get_similar(song.artist.name, song.title)
        new_song = save_track_info(resp)
        new_song
    end

    def pick_song_from_genre(genre)
        indb = [true,false].sample

        if indb
            select_song_from_genre(genre)
        else
            pick_new_song_from_genre(genre)
        end
    end
end