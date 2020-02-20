class Question < ApplicationRecord
    belongs_to :game

    validates :answer, :game, presence: true

    check_perm 'questions#check' do |question, user|
        question.game.user == user
    end
end
