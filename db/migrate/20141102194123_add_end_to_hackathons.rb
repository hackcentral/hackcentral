class AddEndToHackathons < ActiveRecord::Migration
  def change
    add_column :hackathons, :end, :datetime
  end
end
