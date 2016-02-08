class CreateMagazDimensions < ActiveRecord::Migration
  def change
    create_table :magaz_dimensions do |t|
      t.string :code
      t.string :name
      t.string :full_name

      t.timestamps null: false
    end
  end
end
