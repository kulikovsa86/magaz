class AddSeoToCategories < ActiveRecord::Migration
  def change
    add_column :magaz_categories, :title, :string
    add_column :magaz_categories, :meta_description, :text
    add_column :magaz_categories, :meta_keywords, :text
  end
end
