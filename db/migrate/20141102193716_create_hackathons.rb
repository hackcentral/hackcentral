class CreateHackathons < ActiveRecord::Migration
  def change
    create_table :hackathons do |t|
      t.string :name
      t.text :about
      t.string :tagline
      t.string :location
      t.string :slug

      t.timestamps
    end
  end
end
