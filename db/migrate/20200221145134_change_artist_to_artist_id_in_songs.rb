class ChangeArtistToArtistIdInSongs < ActiveRecord::Migration[6.0]
  def change
    rename_column :songs, :artist, :artist_id
    change_column :songs, :artist_id, 'integer USING CAST(artist_id AS integer)'
  end
end
