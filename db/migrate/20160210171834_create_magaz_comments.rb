class CreateMagazComments < ActiveRecord::Migration
  def change
    create_table :magaz_comments do |t|
      t.string :name
      t.text :text
      t.integer :rate
      t.boolean :accepted
      t.belongs_to :product, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
