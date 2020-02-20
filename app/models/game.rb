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
end
