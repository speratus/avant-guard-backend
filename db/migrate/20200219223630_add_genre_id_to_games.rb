class AddGenreIdToGames < ActiveRecord::Migration[6.0]
  def change
    add_reference :games, :genre, null: false, foreign_key: true
  end
end
