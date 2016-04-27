class CreateMagazPropertyArgs < ActiveRecord::Migration
  def change
    create_table :magaz_property_args do |t|
      t.integer :property_id, index: true, foreign_key: true
      t.decimal :min
      t.decimal :max
      t.decimal :step
      t.decimal :default

      t.timestamps null: false
    end
  end
end
