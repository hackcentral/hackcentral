class AddPortfolioStuffToAppplications < ActiveRecord::Migration
  def self.up
    change_table :applications do |t|
      t.string :website
      t.string :github
    end
  end

  def self.down
    remove_string :applications, :website
    remove_string :applications, :github
  end
end
