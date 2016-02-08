class CreateMagazLineItems < ActiveRecord::Migration
  def change
    create_table :magaz_line_items do |t|
      t.references :product, index: true, foreign_key: true
      t.references :variant, index: true, foreign_key: true
      t.decimal :price, :precision => 8, :scale => 2
      t.integer :count
      t.decimal :total_count, :precision => 8, :scale => 3
      t.boolean :manual, default: false
      t.decimal :ratio, :precision => 8, :scale => 3
      t.belongs_to :cart, index: true, foreign_key: true
      t.belongs_to :order, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
