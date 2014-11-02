class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
      t.string :name
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :school_grad
      t.text :bio

      t.timestamps
    end
  end
end
