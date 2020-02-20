class SongGenre < ApplicationRecord
  belongs_to :song
  belongs_to :genre

  validates :song, :genre, presence: true
end
