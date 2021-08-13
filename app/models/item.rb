class Item < ApplicationRecord
  validates :name, :price, presence: true
  validates :name, uniqueness: true

  belongs_to :user
end
