class AddDietaryNeedsToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :dietary_needs, :text
  end
end
