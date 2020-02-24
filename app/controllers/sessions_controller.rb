class SessionsController < ApplicationController

    def create
        user = User.find_by(username: user_params[:username])
        if user && user.authenticate(user_params[:password])
            token = JWT.encode({user_id: user.id}, ENV['JWT_SECRET'])
            render json: {token: token}
        else
            render json: {message: "Incorrect username or password"}
        end
    end

    private

    def user_params
        params.require(:user).permit(:username, :password)
    end
end
