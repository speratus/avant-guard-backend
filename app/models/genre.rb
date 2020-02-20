class Genre < ApplicationRecord
    has_many :song_genres, dependent: :destroy
    has_many :songs, through: :song_genres

    has_many :games

    has_many :genre_scores
end
