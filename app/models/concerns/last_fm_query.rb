require 'json'

module lastFmQuery
    LAST_FM_BASE = "http://ws.audioscrobbler.com/2.0/"
    APPENDIX = "&api_key=#{ENV['LASTFM_KEY']}&format=json"

    def queryArtistTopTracks(artist)
        url = LAST_FM_BASE+ "?method=artist.gettoptracks&artist=#{artist}" + APPENDIX
        result = JSON.parse(RestClient.get(url))
    end
end