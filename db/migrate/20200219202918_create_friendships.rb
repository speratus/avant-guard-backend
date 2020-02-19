class CreateFriendships < ActiveRecord::Migration[6.0]
  def change
    create_table :friendships do |t|
      t.belongs_to :friender, null: false, foreign_key: true, foreign_key: {to_table: :users, on_delete: :cascade}
      t.belongs_to :friended, null: false, foreign_key: true, foreign_key: {to_table: :users, on_delete: :cascade}

      t.timestamps
    end
  end
end
