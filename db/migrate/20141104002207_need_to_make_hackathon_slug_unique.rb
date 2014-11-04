class NeedToMakeHackathonSlugUnique < ActiveRecord::Migration
  def change
    remove_column :hackathons, :slug
  end
end
