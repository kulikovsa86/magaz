class CreateMagazImages < ActiveRecord::Migration
  def change
    create_table :magaz_images do |t|
      t.string :picture
      t.references :imageable, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
