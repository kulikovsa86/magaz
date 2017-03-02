class AddSeoToProducts < ActiveRecord::Migration
  def change
    add_column :magaz_products, :title, :string
    add_column :magaz_products, :meta_description, :text
    add_column :magaz_products, :meta_keywords, :text
  end
end
