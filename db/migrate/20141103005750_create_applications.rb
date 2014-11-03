class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
      t.boolean :reimbursement_needed
      t.boolean :accepted

      t.timestamps
    end
  end
end
