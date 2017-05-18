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

ActiveRecord::Schema.define(version: 20170517192255) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "funnel_models", force: :cascade do |t|
    t.datetime "created_at", :null=>false
    t.datetime "updated_at", :null=>false
  end

  create_table "funnels", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "numTriggers"
    t.float    "numRevenue"
    t.datetime "created_at",  :null=>false
    t.datetime "updated_at",  :null=>false
  end

  create_table "job_queues", force: :cascade do |t|
    t.datetime "created_at", :null=>false
    t.datetime "updated_at", :null=>false
  end

  create_table "mail_funnel_configs", force: :cascade do |t|
    t.string   "name",       :index=>{:name=>"index_mail_funnel_configs_on_name", :unique=>true, :using=>:btree}
    t.string   "value"
    t.datetime "created_at", :null=>false
    t.datetime "updated_at", :null=>false
  end

  create_table "shops", force: :cascade do |t|
    t.string   "shopify_domain", :null=>false, :index=>{:name=>"index_shops_on_shopify_domain", :unique=>true, :using=>:btree}
    t.string   "shopify_token",  :null=>false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "app"
    t.datetime "created_at", :null=>false
    t.datetime "updated_at", :null=>false
  end

end