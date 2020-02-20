class GenreScoresController < ApplicationController

    def index
        genres = check_authorization(Genre.where(user_id: params[:user_id]), current_user)
        render json: basic_genre_data(genres)
    end

    private

    def basic_genre_data(genre)
        genre.as_json(only: [:score], include: {genre: {only: [:name]}})
    end
end
