class CreateOrganizers < ActiveRecord::Migration
  def change
    create_table :organizers do |t|
      t.integer :user_id
      t.integer :hackathon_id

      t.timestamps
    end
    add_index :organizers, :user_id
    add_index :organizers, :hackathon_id
  end
end
