class CreateMagazCategories < ActiveRecord::Migration
  def change
    create_table :magaz_categories do |t|
      t.string :code
      t.string :name
      t.string :description
      t.boolean :hidden
      t.integer :parent_id
      t.integer :sort_order
      t.string :permalink, index: true

      t.timestamps null: false
    end
  end
end
