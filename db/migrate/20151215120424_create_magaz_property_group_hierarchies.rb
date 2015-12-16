class CreateMagazPropertyGroupHierarchies < ActiveRecord::Migration
  def change
    create_table :magaz_property_group_hierarchies do |t|
      t.integer  :ancestor_id, :null => false   # ID of the parent/grandparent/great-grandparent/... property_groups
      t.integer  :descendant_id, :null => false # ID of the target property_groups
      t.integer  :generations, :null => false   # Number of generations between the ancestor and the descendant. Parent/child = 1, for example.
    end

    # For "all progeny of…" and leaf selects:
    add_index :magaz_property_group_hierarchies, [:ancestor_id, :descendant_id, :generations],
              :unique => true, :name => "magaz_property_group_anc_desc_udx"

    # For "all ancestors of…" selects,
    add_index :magaz_property_group_hierarchies, [:descendant_id],
              :name => "magaz_property_group_desc_idx"
  end
end
