class CreateMagazLineItems < ActiveRecord::Migration
  def change
    create_table :magaz_line_items do |t|
      t.references :product, index: true, foreign_key: true
      t.references :variant, index: true, foreign_key: true
      t.decimal :price, :precision => 8, :scale => 2
      t.integer :count
      t.belongs_to :cart, index: true, foreign_key: true
      t.integer :order_id

      t.timestamps null: false
    end
  end
end
