require_relative '../../../last_fm_query'

module GameLogic
    include LastFmQuery

    def save_track_info(track_info)
        track = track_info['track']
        track_name = track['name']
        artist_name = track['artist']['name']
        album_title = track['album']['title']
        release_date = track['wiki']['published']
        listens = track['playcount'].to_i

        genres = track['toptags']['tag'].map do |tag|
            Genre.find_or_create_by(name: tag['name'])
        end

        artist = Artist.find_or_create_by(name: artist_name)

        song = Song.new(
            title: track_name, 
            album: album_title,
            release_date: release_date.split('')[2],
            artist: artist,
            listens: listens
        )

        genres.each |g| {song.genres << g}
        song.save
        artist.save
        song
    end

    def calculate_multiplier(listens, release_date)
        age = (Date.today - Date.parse(release_date)).to_i
        multiplier = age / (Math.log(listens))
    end

    def use_db
        [true,false].sample
    end

    def pull_genre_from_db
        Genre.all.sample
    end

    def pull_artist_from_db
        Artist.all.sample
    end

    def grab_song_from_genre(genre)
        genre.songs.sample
    end

    def grab_song_from_artist(artist)
        artist.songs.sample
    end

    def pick_new_song_from_genre(genre)
        song = grab_song_from_genre(genre)
        resp = track_get_similar(song.artist.name, song.title)
        possible_tracks = resp['similartracks']['track']
        pick = possible_tracks.sample
        track_title = pick['name']
        artist_name = pick['artist']['name']
        data = track_get_info(artist_name, track_title)
        new_song = save_track_info(data)
        new_song
    end

    def pick_song_from_genre(genre)
        if use_db
            grab_song_from_genre(genre)
        else
            pick_new_song_from_genre(genre)
        end
    end

    def pick_new_song_from_artist(artist)
        track_list = artist_top_tracks(artist.name)
        track_data = track_list['toptracks']['track'].sample

        track_title = track_data['name']
        track_info = track_get_info(artist.name, track_title)
        new_song = save_track_info(track_info)
        new_song
    end

    def pick_song_from_artist(artist)
        if use_db
            grab_song_from_artist(artist)
        else
            pick_new_song_from_artist(artist)
        end
    end
end