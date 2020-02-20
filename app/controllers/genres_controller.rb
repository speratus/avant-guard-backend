class GenresController < ApplicationController

    def index
        genres = check_authorization(Genre.all, current_user)
        render json: genres, only: [:name]
    end
end
