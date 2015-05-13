class AddAttachmentAvatarToAutobots < ActiveRecord::Migration
  def self.up
    change_table :autobots do |t|
      t.attachment :avatar
    end
  end

  def self.down
    remove_attachment :autobots, :avatar
  end
end
