class AddAttachmentResumeToApplications < ActiveRecord::Migration
  def self.up
    change_table :applications do |t|
      t.attachment :resume
    end
  end

  def self.down
    remove_attachment :applications, :resume
  end
end
