class AddHackathonIdToSubmissions < ActiveRecord::Migration
  def change
    add_column :submissions, :hackathon_id, :integer
  end
end
