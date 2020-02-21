class DropUnusedTables < ActiveRecord::Migration[6.0]
  def change
    drop_table :artist_genres
    drop_table :artist_songs
  end
end
