class User < ApplicationRecord
  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  validates :email, :password, :name, presence: true
  validates :email, uniqueness: true
  validates_format_of :email, with: EMAIL_REGEX

  has_many :items, dependent: :destroy
end
