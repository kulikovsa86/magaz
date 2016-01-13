class CreateMagazProducts < ActiveRecord::Migration
  def change
    create_table :magaz_products do |t|
      t.string :name
      t.string :var_name
      t.belongs_to :category, index: true, foreign_key: true
      t.text :description
      t.decimal :price, :precision => 8, :scale => 2
      t.boolean :hidden
      t.string :article
      t.decimal :weight, :precision => 6, :scale => 3
      t.integer :position
      t.string :permalink, index: true

      t.timestamps null: false
    end
  end
end
