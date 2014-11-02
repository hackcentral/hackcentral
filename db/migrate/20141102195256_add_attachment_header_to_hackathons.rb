class AddAttachmentHeaderToHackathons < ActiveRecord::Migration
  def self.up
    change_table :hackathons do |t|
      t.attachment :header
    end
  end

  def self.down
    remove_attachment :hackathons, :header
  end
end
