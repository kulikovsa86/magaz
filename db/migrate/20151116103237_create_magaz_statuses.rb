class CreateMagazStatuses < ActiveRecord::Migration
  def change
    create_table :magaz_statuses do |t|
      t.string :code
      t.string :name
      t.text :note
      t.boolean :closed, default: false
      t.integer :position

      t.timestamps null: false
    end
  end
end
