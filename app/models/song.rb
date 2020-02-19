class Song < ApplicationRecord
    has_many :song_genres
    has_many :genres, through: :song_genres
end
