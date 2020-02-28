class UsersController < ApplicationController
    before_action :verify_authentication, except: [:create, :index]

    def create
        user = User.new(user_params)

        if user.save
            render json: basic_user_data(user)
        else
            render json: {
                message: 'Failed to create user',
                errors: user.errors.full_messages
            }
        end
    end

    def index
        users = check_authorization(User.all, current_user)
        render json: basic_user_data(users)
    end

    def show
        render json: basic_user_data(@user)
    end

    def friends
        friends = [@user.friends, @user.frienders]
        friends = friends.flatten.uniq
        render json: basic_user_data(friends)
    end

    def update
        @user.update_attributes(user_params)

        if @user.save
            render json: basic_user_data(@user)
        else
            render json: {
                message: "Update failed",
                errors: @user.errors.full_messages
            }
        end
    end

    def destroy
        if @user.destroy!
            render json: {
                message: 'successfully deleted user!',
                user: basic_user_data(@user)
            }
        else
            render json: {
                message: 'failled to delete user',
                user: basic_user_data(@user)
            }
        end
    end

    private

    def user_params
        params.require(:user).permit(:name, :username, :password, :password_confirmation, :genius_token)
    end

    def verify_authentication
        user = User.find_by(id: params[:id])
        @user = check_authorization(user, current_user)
    end

    def basic_user_data(user)
        user.as_json(only: [:id, :name, :username])
    end
end
