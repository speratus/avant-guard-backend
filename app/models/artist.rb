class Artist < ApplicationRecord
    has_many :songs

    validates :name, presence: true
    validates :name, uniqueness: true

    def genres
        genres = []
        self.songs.each do |s|
            s.genres.each do |g|
                genres << g unless genres.include?(g)
            end
        end
        genres
    end

    check_perm('artists#index') do |artist, user|
        !user.nil?
    end
end
