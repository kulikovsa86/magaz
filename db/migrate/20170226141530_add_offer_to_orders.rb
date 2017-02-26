class AddOfferToOrders < ActiveRecord::Migration
  def change
    add_column :magaz_orders, :offer, :boolean
    add_column :magaz_orders, :offer_sent, :datetime
  end
end
