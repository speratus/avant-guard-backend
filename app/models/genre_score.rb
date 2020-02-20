class GenreScore < ApplicationRecord
  belongs_to :genre
  belongs_to :user

  validates :genre, :user, presence: true
end
