class GenresController < ApplicationController

    def index
        # byebug
        genres = check_authorization(Genre.all, current_user)
        render json: genres, only: [:name]
    end
end
