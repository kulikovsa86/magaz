class CreateMagazProperties < ActiveRecord::Migration
  def change
    create_table :magaz_properties do |t|
      t.string :code
      t.string :name
      t.text :description
      t.references :property_type, index: true, foreign_key: true
      t.boolean :static, default: false
      t.boolean :variant, default: false

      t.integer :position
      t.integer :property_group_id

      t.timestamps null: false
    end
  end
end
