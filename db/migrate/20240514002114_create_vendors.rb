class CreateVendors < ActiveRecord::Migration[7.1]
  def change
    create_table :vendors do |t|
      t.string :name
      t.string :description
      t.string :contact_name
      t.string :contact_phone
      t.boolean :credit_accepted

      t.timestamps
    end
  end
end
