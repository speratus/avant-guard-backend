class GenreScore < ApplicationRecord
  belongs_to :genre
  belongs_to :user

  validates :genre, :user, presence: true

  check_perm 'genre_scores#index' do |scores, user|
    !user.nil?
  end
end
