class CreateMagazSettings < ActiveRecord::Migration
  def change
    create_table :magaz_settings do |t|
      t.string :name
      t.string :value
      t.string :param

      t.timestamps null: false
    end
  end
end
