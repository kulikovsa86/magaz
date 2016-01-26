class CreateMagazVariants < ActiveRecord::Migration
  def change
    create_table :magaz_variants do |t|
      t.belongs_to :product, index: true, foreign_key: true
      t.decimal :price, :precision => 8, :scale => 2
      t.string :name
      t.boolean :hidden, default: false
      t.integer :position

      t.timestamps null: false
    end
  end
end
