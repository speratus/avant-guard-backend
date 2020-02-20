class Question < ApplicationRecord
    belongs_to :game

    validates :answer, :game, presence: true
end
