class CreateTeamMembers < ActiveRecord::Migration
  def change
    create_table :team_members do |t|
      t.integer :submission_id
      t.integer :user_id

      t.timestamps null: false
    end
    add_index :team_members, :submission_id
    add_index :team_members, :user_id
  end
end
