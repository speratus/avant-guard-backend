class UsersController < ApplicationController

    def create
        
    end

    def show

    end

    def update

    end

    def destroy

    end

    private

    def user_params
        params.require(:user).permit(:name, :username, :password, :password_confirmation, :genius_token)
    end
end
