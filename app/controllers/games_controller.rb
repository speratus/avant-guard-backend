class GamesController < ApplicationController
    before_action :verify_game, except: [:create, :index]

    def create
        game = check_authorization(Game.construct(current_user, game_params[:game]), current_user)
        render json: game_challenge(game)
    end

    def update
        @game.calculate_final_score(@game)

        if @game.save
            render json: full_game_data(@game)
        else
            render json: {
                message: 'game failed to update correctly',
                errors: @game.errors.full_messages
            }
        end
    end

    def index
        games = check_authorization(Game.where(user_id: params[:user_id]),current_user)
        render json: basic_game_data(games)
    end

    def show
        render json: full_game_data(@game)
    end

    private
    
    def game_params
        params.require(:game).permit(:genre, :artist)
    end

    def verify_game
        game = Game.find_by(id: params[:id])
        @game = check_authorization(game, current_user)
    end

    def basic_game_data(game)
        game.as_json(only: [:final_score], include: {
            genre: {only: [:name]}
        })
    end

    def full_game_data(game)
        game.as_json(except: [:created_at, :updated_at], include: {
            questions: {except: [:created_at, :updated_at]}
        })
    end

    def game_challenge(game)
        game.as_json(
            only: [:lyrics, :multiplier], 
            include: {
                questions: {only: :question_type}
            }
        )
    end

end
