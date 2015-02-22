class AddRsvpToApplications < ActiveRecord::Migration
  def self.up
    add_column :applications, :rsvp, :boolean, :default => false
  end

  def self.down
    remove_column :applications, :rsvp
  end
end
