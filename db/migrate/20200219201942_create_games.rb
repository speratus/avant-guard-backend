class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.string :multiplier
      t.string :final_score
      t.belongs_to :user
      t.belongs_to :song

      t.timestamps
    end
  end
end
