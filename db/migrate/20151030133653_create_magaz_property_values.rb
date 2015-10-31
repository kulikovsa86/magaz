class CreateMagazPropertyValues < ActiveRecord::Migration
  def change
    create_table :magaz_property_values do |t|
      t.belongs_to :variant, index: true, foreign_key: true
      t.belongs_to :property, index: true, foreign_key: true
      t.string :value

      t.timestamps null: false
    end
  end
end
