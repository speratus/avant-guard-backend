require 'json'

module LastFmQuery
    LAST_FM_BASE = "http://ws.audioscrobbler.com/2.0/"
    APPENDIX = "&api_key=#{ENV['LASTFM_KEY']}&format=json"

    def artist_top_tracks(artist)
        url = LAST_FM_BASE+ "?method=artist.gettoptracks&artist=#{artist}" + APPENDIX
        result = JSON.parse(RestClient.get(url))
    end

    def track_get_info(artist_name, track_name, mbid = nil)
        method = "?method=track.getinfo"
        if mbid
            url = LAST_FM_BASE + method + "&mbid=#{mbid}" + APPENDIX
        else
            url = LAST_FM_BASE + method + "&artist=#{artist_name}&track=#{track_name}" + APPENDIX
        end
        result = JSON.parse(RestClient.get(url))
    end

    def track_get_similar(artist, track, mbid = nil)
        method = "?method=track.getsimilar"
        if mbid
            url = LAST_FM_BASE + method + "&mbid=#{mbid}" + APPENDIX
        else
            url = LAST_FM_BASE + method + "&artist=#{artist}&track=#{track}"
        end
        puts "+++++++++++++++++#{url}"
        result = JSON.parse(RestClient.get(url))
    end

    def chart_get_top_tracks(page = 1, limit = 50)
        method = "?method=chart.gettoptracks"
        args = "&page=#{page}&limit=#{limit}"
        url = LAST_FM_BASE + method + args + APPENDIX
        result = JSON.parse(RestClient.get(url))
    end
end