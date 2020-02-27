module ClipQuery
    extend ActiveSupport::Concern

    included do
        RSpotify.authenticate(ENV['CLIENT_ID'], ENV['CLIENT_SECRET'])
    end

    def search_for_track(song)
        track_list = RSpotify::Track.search(song.title)
        track = track_list.find {|t| t.artists.first.name == song.artist.name}
        if track.nil?
            raise "Could not find #{song.title} by #{song.artist.name} in #{track_list.map {|t| t.name}}"
        end
        track
    end

    def track_details(track_id)
        track = RSpotify::Track.find(track_id)
    end

end