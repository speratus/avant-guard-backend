class FriendshipsController < ApplicationController

    def create
        puts "Received: #{params}"
        friendship = check_authorization(
            Friendship.new(
                friender_id: params[:user_id], 
                friended_id: friendship_params[:friended_id]
            ), 
            current_user
        )

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
        friendship = check_authorization(
            Friendship.find_by(
                friended_id: params[:id],
                friender_id: params[:user_id]
            ), 
            current_user
        )
        return unless friendship
        
        if friendship.destroy
            render json: {
                message: 'destroyed friendship',
                friendship: basic_friendship_data(friendship)
            }
        else
            render json: {
                error: 'failed to destroy friendship'
            }
        end
    end

    private

    def friendship_params
        params.require(:friendship).permit(:friended_id)
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
