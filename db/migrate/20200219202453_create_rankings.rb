class CreateRankings < ActiveRecord::Migration[6.0]
  def change
    create_table :rankings do |t|
      t.integer :total_score
      t.integer :rank
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
