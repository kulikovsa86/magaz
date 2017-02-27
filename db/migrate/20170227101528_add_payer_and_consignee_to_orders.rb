class AddPayerAndConsigneeToOrders < ActiveRecord::Migration
  def change
    add_column :magaz_orders, :payer, :text
    add_column :magaz_orders, :consignee, :text
  end
end
