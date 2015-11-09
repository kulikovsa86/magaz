# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151105072644) do

  create_table "magaz_categories", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.string   "description"
    t.boolean  "hidden"
    t.integer  "parent_id"
    t.integer  "position"
    t.string   "permalink"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "magaz_categories", ["permalink"], name: "index_magaz_categories_on_permalink"

  create_table "magaz_categories_properties", id: false, force: :cascade do |t|
    t.integer "category_id"
    t.integer "property_id"
  end

  add_index "magaz_categories_properties", ["category_id"], name: "index_magaz_categories_properties_on_category_id"
  add_index "magaz_categories_properties", ["property_id"], name: "index_magaz_categories_properties_on_property_id"

  create_table "magaz_category_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id",   null: false
    t.integer "descendant_id", null: false
    t.integer "generations",   null: false
  end

  add_index "magaz_category_hierarchies", ["ancestor_id", "descendant_id", "generations"], name: "magaz_category_anc_desc_udx", unique: true
  add_index "magaz_category_hierarchies", ["descendant_id"], name: "magaz_category_desc_idx"

  create_table "magaz_images", force: :cascade do |t|
    t.string   "picture"
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.integer  "position"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "magaz_images", ["imageable_type", "imageable_id"], name: "index_magaz_images_on_imageable_type_and_imageable_id"

  create_table "magaz_products", force: :cascade do |t|
    t.string   "name"
    t.integer  "category_id"
    t.text     "description"
    t.decimal  "price",       precision: 8, scale: 2
    t.boolean  "hidden"
    t.string   "article"
    t.decimal  "weight",      precision: 6, scale: 3
    t.integer  "position"
    t.string   "permalink"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "magaz_products", ["category_id"], name: "index_magaz_products_on_category_id"
  add_index "magaz_products", ["permalink"], name: "index_magaz_products_on_permalink"

  create_table "magaz_properties", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.integer  "property_type_id"
    t.boolean  "static"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "magaz_properties", ["property_type_id"], name: "index_magaz_properties_on_property_type_id"

  create_table "magaz_property_options", force: :cascade do |t|
    t.integer  "property_id"
    t.string   "code"
    t.string   "name"
    t.integer  "position"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "magaz_property_types", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "magaz_property_values", force: :cascade do |t|
    t.integer  "variant_id"
    t.integer  "property_id"
    t.string   "value"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "magaz_property_values", ["property_id"], name: "index_magaz_property_values_on_property_id"
  add_index "magaz_property_values", ["variant_id"], name: "index_magaz_property_values_on_variant_id"

  create_table "magaz_variants", force: :cascade do |t|
    t.integer  "product_id"
    t.decimal  "price",      precision: 8, scale: 2
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "magaz_variants", ["product_id"], name: "index_magaz_variants_on_product_id"

end
