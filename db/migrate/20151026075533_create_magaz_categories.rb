class CreateMagazCategories < ActiveRecord::Migration
  def change
    create_table :magaz_categories do |t|
      t.string :code
      t.string :name
      t.string :description
      t.boolean :hidden, default: true
      t.integer :parent_id
      t.integer :position
      t.string :permalink, index: true

      t.timestamps null: false
    end
  end
end
