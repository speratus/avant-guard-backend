class User < ApplicationRecord
    attr_encrypted :genius_token, key: ENV['DB_SECRET']

    has_one :ranking

    has_many :genre_scores, dependent: :destroy

    has_many :games, dependent: :destroy

    has_many :friendships, foreign_key: :friender_id, dependent: :destroy
    has_many :friends, through: :friendships, source: :friended
end
