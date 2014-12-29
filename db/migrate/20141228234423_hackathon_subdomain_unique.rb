class HackathonSubdomainUnique < ActiveRecord::Migration
  def change
    remove_column :hackathons, :subdomain
    add_column :hackathons, :subdomain, :string
    add_index :hackathons, :subdomain, unique: true
  end
end
