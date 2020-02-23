class AddFmIdToGenres < ActiveRecord::Migration[6.0]
  def change
    add_column :genres, :fm_id, :integer
  end
end
