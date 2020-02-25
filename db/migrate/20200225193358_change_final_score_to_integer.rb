class ChangeFinalScoreToInteger < ActiveRecord::Migration[6.0]
  def change
    change_column :games, :final_score, 'integer USING CAST(final_score AS integer)'
  end
end
