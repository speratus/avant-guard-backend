class GamesController < ApplicationController
    before_action :verify_game, except: [:create, :index]

    def create
        puts "===========================#{game_params}"
        begin
            game = check_authorization(Game.construct(current_user, game_params), current_user)
        rescue
            puts "******************** INSUFFICIENT DATA ***********************"
            render json: {message: 'Could not find enough data to build game with that artist'}
            return
        end
        puts "--------------Game Lyrics: #{game.lyrics}"
        render json: game_challenge(game)
    end

    def update
        @game.calculate_final_score(@game)

        img = @game.fetch_image(@game.song)

        puts "The image is: #{img}"

        @game.image = img if img

        if @game.save
            # puts "Updating game: #{full_game_data(@game)}"
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
        game.as_json(
            except: [:created_at, :updated_at], 
            methods: [:image],
            include: {
                questions: {except: [:created_at, :updated_at]},
                song: {
                    only: [:id, :title, :release_date, :album],
                    include: {artist: {only: :name}}
                }
        })
    end

    def game_challenge(game)
        game.as_json(
            only: [:id, :multiplier], 
            methods: [:lyrics, :clip_address],
            include: {
                questions: {only: [:id, :question_type]}
            }
        )
    end

end
