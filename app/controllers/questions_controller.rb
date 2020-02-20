class QuestionsController < ApplicationController
    before_action :verify_question

    def check
        @question.input = check_params[:input]

        if @question.save
            if @question.input == @question.answer
                render json: {result: true}
            else
                render json: {result: false}
            end
        else
            render json: {
                message: "There was an error",
                errors: @question.errors.full_messages
            }
        end
    end
    
    private

    def check_params
        params.require(:questio).permit(:input)
    end

    def verify_question
        question = Question.find_by(id: params[:id])
        @question = check_authorization(question, current_user)
    end
end
