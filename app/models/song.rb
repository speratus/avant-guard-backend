class Song < ApplicationRecord
    has_many :song_genres, dependent: :destroy
    has_many :genres, through: :song_genres

    has_many :games

    validates :title, :artist, :release_date, presence: true
    validate :has_at_least_one_genre

    check_perm 'songs#show' do |song, user|
        !user.nil?
    end
    
    def has_at_least_one_genre
        if song.genres.length < 1
            errors[:genres] << 'Songs must have at least one genre'
        end
    end
end
