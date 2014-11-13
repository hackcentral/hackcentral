class AddHsHackersAllowedToHackathons < ActiveRecord::Migration
  def self.up
    add_column :hackathons, :hs_hackers_allowed, :boolean, :default => false
  end

  def self.down
    remove_column :hackathons, :hs_hackers_allowed
  end
end
