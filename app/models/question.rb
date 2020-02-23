class Question < ApplicationRecord

    QUESTION_TYPES = {
        'y': 'What year was this song written in?',
        'al': 'What is the name of the album in which this song appears?',
        'ar': 'Who wrote/performed this song?',
        't': 'What is the name of this song?'
    }

    belongs_to :game

    validates :answer, :game, presence: true

    check_perm 'questions#check' do |question, user|
        question.game.user == user
    end

    def get_question
        QUESTION_TYPES[self.question_type]
    end
end
