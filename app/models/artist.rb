class Artist < ApplicationRecord
    has_many :songs

    def genres
        genres = []
        self.songs.each do |s|
            s.genres.each do |g|
                genres << g unless genres.include?(g)
            end
        end
        genres
    end
end
