class AddFmIdToSongs < ActiveRecord::Migration[6.0]
  def change
    add_column :songs, :fm_id, :integer
  end
end
