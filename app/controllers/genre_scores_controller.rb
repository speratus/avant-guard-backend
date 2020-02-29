class GenreScoresController < ApplicationController

    def index
        genres = check_authorization(GenreScore.where(user_id: params[:user_id]).order('score DESC').limit(10), current_user)
        if genres
            render json: basic_genre_data(genres)
        end
    end

    private

    def basic_genre_data(genre)
        genre.as_json(only: [:score], include: {genre: {only: [:name]}})
    end
end
