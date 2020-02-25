class ChangeMultiplierToInteger < ActiveRecord::Migration[6.0]
  def change
    change_column :games, :multiplier, 'integer USING CAST(multiplier AS integer)'
  end
end
