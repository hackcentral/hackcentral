class AddCheckedInToApplications < ActiveRecord::Migration
  def self.up
    add_column :applications, :checked_in, :boolean, :default => false
  end

  def self.down
    remove_column :applications, :checked_in
  end
end
