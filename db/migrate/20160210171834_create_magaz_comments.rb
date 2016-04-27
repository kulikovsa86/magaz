class CreateMagazComments < ActiveRecord::Migration
  def change
    create_table :magaz_comments do |t|
      t.string :name
      t.text :text
      t.integer :rate
      t.boolean :accepted, default: false
      t.boolean :fresh, default: true
      t.integer :product_id, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
