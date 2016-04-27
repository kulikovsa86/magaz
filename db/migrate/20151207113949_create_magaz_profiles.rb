class CreateMagazProfiles < ActiveRecord::Migration
  def change
    create_table :magaz_profiles do |t|
      t.integer :user_id, index: true, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :email

      t.timestamps null: false
    end
  end
end
