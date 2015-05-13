class Autobot < ActiveRecord::Base
  validates :speed, presence: true, numericality: { greater_than: 0 }
  validates :calories, presence: true, numericality: true
  validates :heart_rate, presence: true, numericality: { only_integer: true }
  validates :rank, presence: true,
    numericality: { only_integer: true },
    uniqueness: {message: "already subscribed"}

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
end
