class AddHackathonIdToApplications < ActiveRecord::Migration
  def change
    add_column :applications, :hackathon_id, :integer
  end
end
