class CreateMagazOrderStatuses < ActiveRecord::Migration
  def change
    create_table :magaz_order_statuses do |t|
      t.integer :order_id, index: true, foreign_key: true
      t.integer :status_id, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
