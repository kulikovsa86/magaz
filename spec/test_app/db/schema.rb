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

ActiveRecord::Schema.define(version: 20160212075546) do

  create_table "magaz_carts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

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

  create_table "magaz_categories_property_groups", id: false, force: :cascade do |t|
    t.integer "category_id"
    t.integer "property_group_id"
  end

  add_index "magaz_categories_property_groups", ["category_id"], name: "index_magaz_categories_property_groups_on_category_id"
  add_index "magaz_categories_property_groups", ["property_group_id"], name: "index_magaz_categories_property_groups_on_property_group_id"

  create_table "magaz_category_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id",   null: false
    t.integer "descendant_id", null: false
    t.integer "generations",   null: false
  end

  add_index "magaz_category_hierarchies", ["ancestor_id", "descendant_id", "generations"], name: "magaz_category_anc_desc_udx", unique: true
  add_index "magaz_category_hierarchies", ["descendant_id"], name: "magaz_category_desc_idx"

  create_table "magaz_comments", force: :cascade do |t|
    t.string   "name"
    t.text     "text"
    t.integer  "rate"
    t.boolean  "accepted"
    t.integer  "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "magaz_comments", ["product_id"], name: "index_magaz_comments_on_product_id"

  create_table "magaz_deliveries", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.text     "note"
    t.boolean  "address_required"
    t.boolean  "post_code_required"
    t.decimal  "price",              precision: 8, scale: 2
    t.integer  "position"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  create_table "magaz_dimensions", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.string   "full_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "magaz_images", force: :cascade do |t|
    t.string   "picture"
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.integer  "position"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "magaz_images", ["imageable_type", "imageable_id"], name: "index_magaz_images_on_imageable_type_and_imageable_id"

  create_table "magaz_line_items", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "variant_id"
    t.decimal  "price",       precision: 8, scale: 2
    t.integer  "count"
    t.decimal  "total_count", precision: 8, scale: 3
    t.boolean  "manual",                              default: false
    t.decimal  "ratio",       precision: 8, scale: 3
    t.integer  "cart_id"
    t.integer  "order_id"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
  end

  add_index "magaz_line_items", ["cart_id"], name: "index_magaz_line_items_on_cart_id"
  add_index "magaz_line_items", ["order_id"], name: "index_magaz_line_items_on_order_id"
  add_index "magaz_line_items", ["product_id"], name: "index_magaz_line_items_on_product_id"
  add_index "magaz_line_items", ["variant_id"], name: "index_magaz_line_items_on_variant_id"

  create_table "magaz_order_statuses", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "status_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "magaz_order_statuses", ["order_id"], name: "index_magaz_order_statuses_on_order_id"
  add_index "magaz_order_statuses", ["status_id"], name: "index_magaz_order_statuses_on_status_id"

  create_table "magaz_orders", force: :cascade do |t|
    t.string   "customer"
    t.string   "company"
    t.string   "phone"
    t.string   "email"
    t.integer  "delivery_id"
    t.string   "address1"
    t.string   "address2"
    t.string   "address3"
    t.string   "address4"
    t.string   "post_code"
    t.integer  "payment_id"
    t.integer  "status_id"
    t.datetime "pdt"
    t.text     "customer_comment"
    t.text     "manager_comment"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "magaz_orders", ["delivery_id"], name: "index_magaz_orders_on_delivery_id"
  add_index "magaz_orders", ["payment_id"], name: "index_magaz_orders_on_payment_id"
  add_index "magaz_orders", ["status_id"], name: "index_magaz_orders_on_status_id"

  create_table "magaz_payments", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.text     "note"
    t.integer  "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "magaz_products", force: :cascade do |t|
    t.string   "name"
    t.string   "var_name"
    t.integer  "category_id"
    t.text     "description"
    t.decimal  "price",        precision: 8, scale: 2
    t.boolean  "hidden",                               default: false
    t.string   "article"
    t.decimal  "weight",       precision: 6, scale: 3
    t.integer  "position"
    t.string   "permalink"
    t.integer  "input_dim_id"
    t.integer  "calc_dim_id"
    t.boolean  "correct",                              default: false
    t.boolean  "moulded",                              default: false
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
  end

  add_index "magaz_products", ["category_id"], name: "index_magaz_products_on_category_id"
  add_index "magaz_products", ["permalink"], name: "index_magaz_products_on_permalink"

  create_table "magaz_profiles", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "magaz_profiles", ["user_id"], name: "index_magaz_profiles_on_user_id"

  create_table "magaz_properties", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.text     "description"
    t.integer  "property_type_id"
    t.boolean  "static",            default: false
    t.boolean  "variant",           default: false
    t.integer  "position"
    t.integer  "property_group_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "magaz_properties", ["property_type_id"], name: "index_magaz_properties_on_property_type_id"

  create_table "magaz_property_args", force: :cascade do |t|
    t.integer  "property_id"
    t.decimal  "min"
    t.decimal  "max"
    t.decimal  "step"
    t.decimal  "default"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "magaz_property_args", ["property_id"], name: "index_magaz_property_args_on_property_id"

  create_table "magaz_property_group_hierarchies", force: :cascade do |t|
    t.integer "ancestor_id",   null: false
    t.integer "descendant_id", null: false
    t.integer "generations",   null: false
  end

  add_index "magaz_property_group_hierarchies", ["ancestor_id", "descendant_id", "generations"], name: "magaz_property_group_anc_desc_udx", unique: true
  add_index "magaz_property_group_hierarchies", ["descendant_id"], name: "magaz_property_group_desc_idx"

  create_table "magaz_property_groups", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.integer  "parent_id"
    t.integer  "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

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
    t.integer  "property_id"
    t.string   "value"
    t.integer  "valuable_id"
    t.string   "valuable_type"
    t.integer  "position"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "magaz_property_values", ["property_id"], name: "index_magaz_property_values_on_property_id"
  add_index "magaz_property_values", ["valuable_type", "valuable_id"], name: "index_magaz_property_values_on_valuable_type_and_valuable_id"

  create_table "magaz_settings", force: :cascade do |t|
    t.string   "name"
    t.string   "value"
    t.string   "param"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "magaz_statuses", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.text     "note"
    t.boolean  "closed",     default: false
    t.integer  "position"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "magaz_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "magaz_users", ["email"], name: "index_magaz_users_on_email", unique: true
  add_index "magaz_users", ["reset_password_token"], name: "index_magaz_users_on_reset_password_token", unique: true

  create_table "magaz_variant_images", force: :cascade do |t|
    t.integer  "variant_id"
    t.integer  "image_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "magaz_variants", force: :cascade do |t|
    t.integer  "product_id"
    t.decimal  "price",      precision: 8, scale: 2
    t.string   "name"
    t.boolean  "hidden",                             default: false
    t.integer  "position"
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
  end

  add_index "magaz_variants", ["product_id"], name: "index_magaz_variants_on_product_id"

end
