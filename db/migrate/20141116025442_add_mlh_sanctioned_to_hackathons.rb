class AddMlhSanctionedToHackathons < ActiveRecord::Migration
  def self.up
    add_column :hackathons, :mlh_sanctioned, :boolean, :default => false
  end

  def self.down
    remove_column :hackathons, :mlh_sanctioned
  end
end
