class CreateMagazStatuses < ActiveRecord::Migration
  def change
    create_table :magaz_statuses do |t|
      t.string :code
      t.string :name
      t.text :note

      t.timestamps null: false
    end
  end
end
