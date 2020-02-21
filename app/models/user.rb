class User < ApplicationRecord
    attr_encrypted :genius_token, key: ENV['DB_SECRET']

    has_one :ranking, dependent: :destroy

    has_many :genre_scores, dependent: :destroy

    has_many :games, dependent: :destroy

    has_many :friendships, foreign_key: :friender_id, dependent: :destroy
    has_many :friends, through: :friendships, source: :friended

    has_many :frienders, through: :friendships, source: :friender

    validates :name, :username, :password, :genius_token, presence: true
    validates :username, uniqueness: true

    check_perm 'users#show' do |user, current_user|
        !current_user.nil?
    end

    check_perm 'users#destroy', 'users#update' do |user, current_user|
        user == current_user
    end
end
