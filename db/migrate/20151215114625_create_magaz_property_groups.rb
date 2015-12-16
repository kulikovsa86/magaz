class CreateMagazPropertyGroups < ActiveRecord::Migration
  def change
    create_table :magaz_property_groups do |t|
      t.string :name
      t.string :code
      t.integer :parent_id
      t.integer :position

      t.timestamps null: false
    end
  end
end
