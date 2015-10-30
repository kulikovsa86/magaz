class CreateMagazProperties < ActiveRecord::Migration
  def change
    create_table :magaz_properties do |t|
      t.string :code
      t.string :name
      t.references :property_type, index: true, foreign_key: true
      t.boolean :static

      t.timestamps null: false
    end
  end
end
