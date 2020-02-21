class AddListensToSong < ActiveRecord::Migration[6.0]
  def change
    add_column :songs, :listens, :integer
  end
end
