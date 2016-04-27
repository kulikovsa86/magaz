class CreateMagazPropertyValues < ActiveRecord::Migration
  def change
    create_table :magaz_property_values do |t|
      t.integer :property_id, index: true, foreign_key: true
      t.string :value
      t.references :valuable, polymorphic: true, index: true
      t.integer :position

      t.timestamps null: false
    end
  end
end
