class CreateMagazPropertyKinds < ActiveRecord::Migration
  def change
    create_table :magaz_property_kinds do |t|
      t.string :code
      t.string :name

      t.timestamps null: false
    end

    # add_column :magaz_properties, :property_kind_id, :integer
    add_reference :magaz_properties, :property_kind, index: true
    add_foreign_key :magaz_properties, :property_kinds

  end
end
