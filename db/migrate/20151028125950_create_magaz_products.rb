class CreateMagazProducts < ActiveRecord::Migration
  def change
    create_table :magaz_products do |t|
      t.string :name
      t.string :var_name
      t.integer :category_id, index: true, foreign_key: true
      t.text :description
      t.decimal :price, :precision => 8, :scale => 2
      t.boolean :hidden, default: true
      t.string :article
      t.decimal :weight, :precision => 6, :scale => 3
      t.integer :position
      t.string :permalink, index: true
      t.integer :input_dim_id
      t.integer :calc_dim_id
      t.boolean :correct, default: false
      t.boolean :moulded, default: false
      t.integer :stock, default: 0

      t.timestamps null: false
    end
  end
end
