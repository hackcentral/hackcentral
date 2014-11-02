class AddStartToHackathons < ActiveRecord::Migration
  def change
    add_column :hackathons, :start, :datetime
  end
end
