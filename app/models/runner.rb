class Runner < ActiveRecord::Base
  validates :email, presence: true,
    uniqueness: {message: "already subscribed"},
    format: {
      with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i,
      message: "invalid email"
    }
  validates :password, presence: true,
    length: {
      minimum: 6,
      maximum: 20,
      too_short: "must have at least %{count} words",
      too_long: "must have at most %{count} words"
    },
    :on => :create
  validates :age, numericality: { only_integer: true }

  has_secure_password

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
end
