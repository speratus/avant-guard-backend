class Game < ApplicationRecord
    belongs_to :user
    belongs_to :song
    belongs_to :genre

    has_many :questions, dependent: :destroy

    validates :multiplier, :user, :song, :genre, presence: true

    check_perm 'games#create' do |game, user|
        !user.nil?
    end

    check_perm 'games#update', 'games#show', 'games#index' do |game, user|
        game.user == user
    end

    def self.construct
        #SONG CHOOSING PROCEDURE
        #
        # 1. 50/50 chance to pick song in db or out of db
        # 2. If in db, select one from genre/artist
        # 3. If not in db, pick song in db, then lastfm for similar songs
        # 4. pick one from list and query for details
        # 5. save to db
    end
end
