class AddAttachmentAvatarToRunners < ActiveRecord::Migration
  def self.up
    change_table :runners do |t|
      t.attachment :avatar
    end
  end

  def self.down
    remove_attachment :runners, :avatar
  end
end
