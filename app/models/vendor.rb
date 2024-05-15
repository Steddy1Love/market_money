class Vendor < ApplicationRecord
  has_many :market_vendors
  has_many :markets, through: :market_vendors
  def vendor_count
    market.self.count
  end
end
