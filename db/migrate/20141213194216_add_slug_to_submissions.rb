class AddSlugToSubmissions < ActiveRecord::Migration
  def change
    add_column :submissions, :slug, :string
    add_index :submissions, :slug, unique: true
  end
end
