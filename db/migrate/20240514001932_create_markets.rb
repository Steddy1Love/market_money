class CreateMarkets < ActiveRecord::Migration[7.1]
  def change
    create_table :markets do |t|
      t.string :name
      t.string :street
      t.string :city
      t.string :county
      t.string :zip
      t.string :lat
      t.string :lon

      t.timestamps
    end
  end
end
