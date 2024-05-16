class CreateMarketVendors < ActiveRecord::Migration[7.1]
  def change
    create_table :market_vendors do |t|
      t.references :market, null: false, foreign_key: true
      t.references :vendor, null: false, foreign_key: true

      t.timestamps
    end
  end
end
