class AddShortNameToProducts < ActiveRecord::Migration
  def change
    add_column :magaz_products, :short_name, :string
  end
end
