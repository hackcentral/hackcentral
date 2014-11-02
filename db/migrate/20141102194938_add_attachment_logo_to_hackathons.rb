class AddAttachmentLogoToHackathons < ActiveRecord::Migration
  def self.up
    change_table :hackathons do |t|
      t.attachment :logo
    end
  end

  def self.down
    remove_attachment :hackathons, :logo
  end
end
