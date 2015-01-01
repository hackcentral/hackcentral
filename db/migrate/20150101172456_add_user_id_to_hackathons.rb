class AddUserIdToHackathons < ActiveRecord::Migration
  def change
    add_column :hackathons, :user_id, :integer
    add_index :hackathons, :user_id
  end
end
