require 'json'

module HappiQuery
    BASE_ADDRESS = "https://api.happi.dev/v1/music"

    def search(query, type, limit = 50)
        url = BASE_ADDRESS + "?q=#{query}&type=#{type}&limit=#{limit}"
        result = JSON.parse(RestClient.get(url))
    end

    def albums(artist_id:nil, url:nil)
        if (artist_id)
            url = BASE_ADDRESS + "/artists/#{artist_id}/albums"
            return result = JSON.parse(RestClient.get(url))
        end

        if (url)
            return JSON.parse(RestClient.get(url))
        end

        raise ArgumentError, 'You need to input either an artist_id or a url'
    end

    def tracks(artist_id:nil, album_id:nil, url:nil)
        if (url)
            return JSON.parse(RestClient.get(url))
        end

        if (album_id)
            url = BASE_ADDRESS + "/artists/#{artist_id}/albums/#{album_id}/tracks"
            return JSON.parse(RestClient.get(url))
        end

        raise ArgumentError, 'You need to include either an artist_id and album_id or a url'
    end

    def lyrics(artist_id:nil, album_id:nil, track_id:nil, url:nil)
        if (url)
            return JSON.parse(RestClient.get(url))
        end

        if (track_id)
            url = BASE_ADDRESS + "/artists/#{artist_id}/albums/#{album_id}/tracks/#{track_id}/lyrics"
            return JSON.parse(RestClient.get(url))
        end
    end
end