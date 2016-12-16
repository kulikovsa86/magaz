class AddPermalinkToVariant < ActiveRecord::Migration
  def self.up
    add_column :magaz_variants, :permalink, :string
    add_index :magaz_variants, :permalink
  end
  def self.down
    remove_column :magaz_variants, :permalink
  end
end