class AddProfileIdToApplications < ActiveRecord::Migration
  def change
    add_column :applications, :profile_id, :integer
    add_index :applications, :profile_id
  end
end
