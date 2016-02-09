class CreateMagazPayments < ActiveRecord::Migration
  def change
    create_table :magaz_payments do |t|
      t.string :code
      t.string :name
      t.text :note
      t.integer :position

      t.timestamps null: false
    end
  end
end
