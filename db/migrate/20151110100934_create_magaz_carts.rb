class CreateMagazCarts < ActiveRecord::Migration
  def change
    create_table :magaz_carts do |t|

      t.timestamps null: false
    end
  end
end
