class CreateMagazPropertyArgs < ActiveRecord::Migration
  def change
    create_table :magaz_property_args do |t|
      t.belongs_to :property, index: true, foreign_key: true
      t.decimal :min
      t.decimal :max
      t.decimal :step
      t.decimal :default

      t.timestamps null: false
    end
  end
end
