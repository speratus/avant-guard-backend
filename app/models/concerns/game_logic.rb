require_relative '../../../lib/last_fm_query'
require_relative '../../../lib/nokogiri_lyrics'

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

        genres.each {|g| song.genres << g}
        song.save
        artist.save
        song
    end

    def calculate_multiplier(listens, release_date)
        age = (Date.today - Date.parse(release_date)).to_i
        multiplier = age / (Math.log(listens))
        multiplier.ceil
    end

    def calculate_final_score(game)
        correct = game.questions.map do |q|
            puts "------------#{q.input}; #{q.answer}"
            q.input == q.answer ? 1 : 0
        end

        puts "++++++++++++++++++++++++"
        puts "the correct array looks like: #{correct}"

        final_score = correct.reduce(0) do |agg, c|
            puts "--------------"
            puts "agg #{agg}; #{c}; #{game.multiplier}"
            agg + (c * game.multiplier)
        end

        game.final_score = final_score
        game.save
        final_score
    end

    def use_db
        [true].sample
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

    def url_safe(string)
        URI.encode(string)
    end

    def pick_new_song_from_genre(genre)
        song = grab_song_from_genre(genre)
        resp = track_get_similar(url_safe(song.artist.name), url_safe(song.title))
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


    def lyrics_sample(song)
        puts song.title
        raw_lyrics = NokogiriLyrics::get_results(song.title, song.artist.name)
        line_by_line = raw_lyrics.split("\n")
        lines = line_by_line[2..-1]
        delimit_verses = lines.map {|l| l == "" ? "__" : l}.join("\n")
        verses = delimit_verses.split("__")
        verses.sample
    end
end