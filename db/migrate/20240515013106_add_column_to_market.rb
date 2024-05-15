class AddColumnToMarket < ActiveRecord::Migration[7.1]
  def change
    add_column :markets, :state, :string
  end
end
