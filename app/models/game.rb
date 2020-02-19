class Game < ApplicationRecord
    belongs_to :user
    belongs_to :song
    belongs_to :genre
end
