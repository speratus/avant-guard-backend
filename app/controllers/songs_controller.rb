class SongsController < ApplicationController
    before_action :authorize_song

    def show
        render json: base_song_info(song)
    end

    private

    def authorize_song
        song = Song.find_by(params[:id])
        @song = check_authorization(song, current_user)
    end

    def base_song_info(song)
        song.as_json(except: :created_at, :updated_at)
    end
end
