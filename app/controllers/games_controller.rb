class GamesController < ApplicationController
    before_action :verify_game, except: [:create, :index]

    def create

    end

    def update
        #TODO: Update the following logic to game.calculate_final_score
        # when that logic is implemented.
        ############################
        correct = @game.questions.map do |q|
            q.input == q.answer ? 1 : 0
        end

        final_score = correct.reduce do |agg, c|
            agg + (c * @game.multiplier)
        end

        @game.final_score = final_score
        ###################################

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

end
