class CreateMagazImages < ActiveRecord::Migration
  def change
    create_table :magaz_images do |t|
      t.string :picture
      t.references :imageable, polymorphic: true, index: true
      t.integer :position
      
      t.timestamps null: false
    end

    create_table :magaz_variant_images do |t|
      t.belongs_to :variant
      t.belongs_to :image
    end
  end
end
