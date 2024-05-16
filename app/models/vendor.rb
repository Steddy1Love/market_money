class Vendor < ApplicationRecord
  has_many :market_vendors
  has_many :markets, through: :market_vendors

  validates :contact_name, presence: true
  validates :contact_phone, presence: true
end
