class CreateMagazPropertyTypes < ActiveRecord::Migration
  def change
    create_table :magaz_property_types do |t|
      t.string :code
      t.string :name

      t.timestamps null: false
    end
  end
end
