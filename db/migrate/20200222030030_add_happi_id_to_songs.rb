class AddHappiIdToSongs < ActiveRecord::Migration[6.0]
  def change
    add_column :songs, :happi_url, :string
  end
end
