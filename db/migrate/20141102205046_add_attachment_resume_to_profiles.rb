class AddAttachmentResumeToProfiles < ActiveRecord::Migration
  def self.up
    change_table :profiles do |t|
      t.attachment :resume
    end
  end

  def self.down
    remove_attachment :profiles, :resume
  end
end
