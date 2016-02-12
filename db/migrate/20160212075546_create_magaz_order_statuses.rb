class CreateMagazOrderStatuses < ActiveRecord::Migration
  def change
    create_table :magaz_order_statuses do |t|
      t.belongs_to :order, index: true, foreign_key: true
      t.belongs_to :status, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
