require 'json'

module HappiQuery
    BASE_ADDRESS = "https://api.happi.dev/v1/music"
    APPENDIX = "?apikey=#{ENV['HAPPY_KEY']}"

    def search(query, type, limit = 50)
        url = BASE_ADDRESS + "?q=#{query}&type=#{type}&limit=#{limit}&apikey=#{ENV['HAPPI_KEY']}"
        result = JSON.parse(RestClient.get(url))
    end

    def albums(artist_id:nil, url:nil)
        if (artist_id)
            url = BASE_ADDRESS + "/artists/#{artist_id}/albums" + APPENDIX
            return result = JSON.parse(RestClient.get(url))
        end

        if (url)
            return JSON.parse(RestClient.get(url + APPENDIX))
        end

        raise ArgumentError, 'You need to input either an artist_id or a url'
    end

    def tracks(artist_id:nil, album_id:nil, url:nil)
        if (url)
            return JSON.parse(RestClient.get(url + APPENDIX))
        end

        if (album_id)
            url = BASE_ADDRESS + "/artists/#{artist_id}/albums/#{album_id}/tracks" + APPENDIX
            return JSON.parse(RestClient.get(url))
        end

        raise ArgumentError, 'You need to include either an artist_id and album_id or a url'
    end

    def lyrics(artist_id:nil, album_id:nil, track_id:nil, url:nil)
        if (url)
            return JSON.parse(RestClient.get(url + APPENDIX))
        end

        if (track_id)
            url = BASE_ADDRESS + "/artists/#{artist_id}/albums/#{album_id}/tracks/#{track_id}/lyrics" + APPENDIX
            return JSON.parse(RestClient.get(url))
        end
    end

    def query(url)
        JSON.parse(RestClient.get(url + APPENDIX))
    end

    def get_lyrics_for_song(song)
        res = search(song.artist.name, 'artist')
        artists = res['result']
        target_a = artists.find {|a| a['artist'] === song.artist.name}
        album_query = query(target_a['api_artist']+'/albums')
        album_data = album_query['result']['albums']
        album = album_data.find {|a| a['album'].start_with?(song.album)}
        tracks_query = query(album['api_tracks'])
        tracks_data = tracks_query['result']['tracks']
        track = tracks_data.find {|t| t['track'].start_with?(song.title)}
        lyrics_url = track['api_lyrics']
        song.happi_url = lyrics_url
        song.save

        lyrics_query = query(lyrics_url)
    end
end