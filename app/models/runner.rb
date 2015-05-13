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
    }
  validates :age, numericality: { only_integer: true }
end
