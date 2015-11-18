class CreateMagazDeliveries < ActiveRecord::Migration
  def change
    create_table :magaz_deliveries do |t|
      t.string :code
      t.string :name
      t.text :note
      t.boolean :address_required
      t.boolean :post_code_required
      t.decimal :price, :precision => 8, :scale => 2

      t.timestamps null: false
    end
  end
end
