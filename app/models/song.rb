class Song < ApplicationRecord
    has_many :song_genres, dependent: :destroy
    has_many :genres, through: :song_genres
end
