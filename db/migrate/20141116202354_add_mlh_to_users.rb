class AddMlhToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :mlh, :boolean, :default => false
  end

  def self.down
    remove_column :users, :mlh
  end
end
