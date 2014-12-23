class RemoveUnnecessaryAttributesFromProfiles < ActiveRecord::Migration
  def change
    remove_column :profiles, :first_name
    remove_column :profiles, :last_name
    remove_column :profiles, :email
    remove_column :profiles, :bio
  end
end
