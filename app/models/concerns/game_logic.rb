require_relative '../../../lib/last_fm_query'
require_relative '../../../lib/nokogiri_lyrics'

module GameLogic
    include LastFmQuery

    def save_track_info(track_info)
        track = track_info['track']
        track_name = track['name']
        artist_name = track['artist']['name']
        album_title = track['album'] ? track['album']['title'] : 'Single'
        release_date = track['wiki']['published'] if track['wiki']

        unless release_date
            raise "Please pick a new song. That song does not have published info"
        end

        listens = track['playcount'].to_i

        genres = track['toptags']['tag'].map do |tag|
            Genre.find_or_create_by(name: tag['name'])
        end

        artist = Artist.find_or_create_by(name: artist_name)

        song = Song.new(
            title: track_name, 
            album: album_title,
            release_date: release_date,
            artist: artist,
            listens: listens
        )

        genres.each {|g| song.genres << g}
        song.save
        artist.save
        song
    end

    def fetch_image(song)
        artist_name = song.artist.name
        song_name = song.title
        results = track_get_info(artist_name, song_name)
        if results['track']['album']
            return results['track']['album']['image'][2]["#text"]
        end
        nil
    end

    def calculate_multiplier(listens, release_date)
        age = (Date.today - Date.parse(release_date)).to_i
        multiplier = age / (Math.log(listens))
        multiplier.ceil
    end

    def check_whether_input_correct(input, correct_answer)
        return input == correct_answer if input.to_i > 0 && correct_answer.to_i > 0
        dist = DamerauLevenshtein.distance(input, correct_answer)
        dist <= 3
    end

    def calculate_final_score(game)
        correct = game.questions.map do |q|
            puts "------------#{q.input}; #{q.answer}"
            check_whether_input_correct(q.input, q.answer) ? 1 : 0
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

        game.user.calculate_genre_scores(game.genre)
        game.user.calculate_ranking
        final_score
    end

    def use_db
        [true, false].sample
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

        unless pick
            puts "That track has no similar songs"
            return pick_song_from_genre(genre)
        end

        track_title = pick['name']
        artist_name = pick['artist']['name']
        data = track_get_info(url_safe(artist_name), url_safe(track_title))

        begin
            # byebug
            new_song = save_track_info(data)
        rescue
            puts "Could not find any songs like #{song.title}, trying again."
            return pick_song_from_genre(genre)
        end
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
        track_info = track_get_info(url_safe(artist.name), url_safe(track_title))
        puts "************* Track info: #{track_info}"
        begin
            new_song = save_track_info(track_info)
        rescue
            puts "Could not find a track with published info"
            return pick_song_from_artist(artist)
        end
        new_song
    end

    def pick_song_from_artist(artist)
        if use_db
            grab_song_from_artist(artist)
        else
            pick_new_song_from_artist(artist)
        end
    end

    def random_song(options)
        if options['genre']
            genre = Genre.find_by(name: options['genre'])
            song = game.pick_song_from_genre(genre)
        elsif options['artist']
            artist = Artist.find_by(name: options['artist'])
            song = game.pick_song_from_artist(artist)
        else
            raise ArgumentError, 'You must specify either a genre or an artist!'
            return
        end
        song
    end

    def get_clip(song)
        result = search_for_track(song)
        details = track_details(result.id)

        raise "No preview available for #{song.title}, please pick a different song" if details.preview_url.nil?

        details.preview_url
    end


    def lyrics_sample(song)
        puts song.title
        raw_lyrics = NokogiriLyrics::get_results(song.title, song.artist.name)

        unless raw_lyrics.include?("\n")
            return raw_lyrics
        end

        line_by_line = raw_lyrics.split("\n")
        lines = line_by_line[2..-1]
        delimit_verses = lines.map {|l| l == "" ? "__" : l}.join("\n")
        verses = delimit_verses.split("__")
        verses.sample
    end
end