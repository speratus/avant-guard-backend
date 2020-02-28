class FriendshipsController < ApplicationController

    def create
        puts "Received: #{params}"
        friendship = check_authorization(Friendship.new(friendship_params), current_user)

        if friendship.save
            render json: basic_friendship_data(friendship)
        else
            render json: {
                message: 'friendship failed to save',
                errors: friendship.errors.full_messages
            }
        end
    end

    def destroy
        friendship = check_authorization(Friendship.find_by(id: params[:id]), current_user)
        friendship.destroy

        render json: {
            message: 'destroyed friendship',
            friendship: basic_friendship_data(friendship)
        }
    end

    private

    def friendship_params
        params.require(:friendship).permit(:friender_id, :friended_id)
    end

    def basic_friendship_data(friendship)
        friendship.as_json(
            include: {
                friender: {only: [:id, :username]},
                friended: {only: [:id, :username]}
            }
        )
    end
end
