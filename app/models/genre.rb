class Genre < ApplicationRecord
    has_many :song_genres, dependent: :destroy
    has_many :songs, through: :song_genres

    has_many :games

    has_many :genre_scores

    validates :name, presence: true

    check_perm 'genres#index' do |genre, user|
        !user.nil?
    end
end
