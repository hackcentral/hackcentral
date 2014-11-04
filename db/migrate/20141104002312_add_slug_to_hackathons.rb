class AddSlugToHackathons < ActiveRecord::Migration
  def change
    add_column :hackathons, :slug, :string
    add_index :hackathons, :slug, unique: true
  end
end
