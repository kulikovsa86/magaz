class AddNoteToLineItem < ActiveRecord::Migration
  def change
    add_column :magaz_line_items, :note, :string
  end
end
