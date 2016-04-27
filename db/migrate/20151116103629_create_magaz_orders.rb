class CreateMagazOrders < ActiveRecord::Migration
  def change
    create_table :magaz_orders do |t|
      t.string :customer
      t.string :company
      t.string :phone
      t.string :email
      t.integer :delivery_id, index: true, foreign_key: true
      t.string :address1
      t.string :address2
      t.string :address3
      t.string :address4
      t.string :post_code
      t.integer :payment_id, index: true, foreign_key: true
      t.integer :status_id, index: true, foreign_key: true
      t.datetime :pdt # preferred delivery datetime
      t.text :customer_comment
      t.text :manager_comment

      t.timestamps null: false
    end
  end
end
