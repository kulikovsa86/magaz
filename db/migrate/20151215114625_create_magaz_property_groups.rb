class CreateMagazPropertyGroups < ActiveRecord::Migration
  def change
    create_table :magaz_property_groups do |t|
      t.string :name
      t.string :code
      t.integer :parent_id
      t.integer :position

      t.timestamps null: false
    end

    create_table :magaz_categories_property_groups, id: false do |t|
      t.belongs_to :category, index: true
      t.belongs_to :property_group, index: true
    end
  end
end
