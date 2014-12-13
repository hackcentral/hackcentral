class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.integer :user_id
      t.integer :submission_id

      t.timestamps
    end
    add_index :likes, :user_id
    add_index :likes, :submission_id
  end
end
