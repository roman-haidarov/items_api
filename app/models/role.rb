class Role < ApplicationRecord
  validates :permission, presence: true

  has_many :user_role, dependent: :destroy
  has_many :users, through: :user_role
end
