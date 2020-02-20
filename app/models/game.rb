class Game < ApplicationRecord
    belongs_to :user
    belongs_to :song
    belongs_to :genre

    has_many :questions, dependent: :destroy

    validates :multiplier, :user, :song, :genre, presence: true
    
end
