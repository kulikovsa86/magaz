class CreateMagazPropertyOptions < ActiveRecord::Migration
  def change
    create_table :magaz_property_options do |t|
      t.integer :property_id
      t.string :code
      t.string :name
      t.integer :position

      t.timestamps null: false
    end
  end
end
