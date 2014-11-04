class AddUserIdToSubmissions < ActiveRecord::Migration
  def change
    add_column :submissions, :user_id, :integer
    add_index :submissions, :user_id
  end
end
