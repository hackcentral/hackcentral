class AddSubmittedAtToSubmissions < ActiveRecord::Migration
  def change
    add_column :submissions, :submitted_at, :datetime
  end
end
