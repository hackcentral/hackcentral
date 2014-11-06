class ApplicationAcceptedDefaultToFalse < ActiveRecord::Migration
  def change
    remove_column :applications, :accepted
    remove_column :hackathons, :accepted
    add_column :applications, :accepted, :boolean, :default => false
    add_index :applications, :accepted
  end
end
