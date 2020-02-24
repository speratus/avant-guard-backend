class ArtistsController < ApplicationController

    def index
        artists = check_authorization(Artist.all, current_user)
        render json: artists, only: [:name]
    end
end
