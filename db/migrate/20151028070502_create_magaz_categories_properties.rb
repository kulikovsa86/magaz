class CreateMagazCategoriesProperties < ActiveRecord::Migration
  def change
    create_table :magaz_categories_properties, id: false do |t|
      t.belongs_to :category, index: true
      t.belongs_to :property, index: true
    end
  end
end
