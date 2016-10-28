class ChangeDescriptionType < ActiveRecord::Migration
  def change
    change_column :magaz_categories, :description, :text
  end
end
