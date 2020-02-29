class QuestionsController < ApplicationController
    include GameLogic

    before_action :verify_question

    def check
        @question.input = check_params[:answer]

        if @question.save
            if check_whether_input_correct(@question.input, @question.answer)
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
        params.require(:question).permit(:answer)
    end

    def verify_question
        question = Question.find_by(id: params[:id])
        @question = check_authorization(question, current_user)
    end
end
