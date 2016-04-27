class CreateMagazLineItems < ActiveRecord::Migration
  def change
    create_table :magaz_line_items do |t|
      t.integer :product_id, index: true, foreign_key: true
      t.integer :variant_id, index: true, foreign_key: true
      t.decimal :price, :precision => 8, :scale => 2
      t.integer :count
      t.decimal :total_count, :precision => 8, :scale => 3
      t.boolean :manual, default: false
      t.decimal :ratio, :precision => 8, :scale => 3
      t.references :liable, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
