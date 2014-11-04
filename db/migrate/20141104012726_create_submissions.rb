class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.stirng :title
      t.string :tagline
      t.text :description
      t.string :video
      t.string :website

      t.timestamps
    end
  end
end
