# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 6) do

  create_table "hosts", :force => true do |t|
    t.string   "name"
    t.integer  "ip"
    t.datetime "scan_start"
    t.datetime "scan_end"
    t.integer  "vulnerabilities_count", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "scan_id"
    t.integer  "location_id",           :default => 0
  end

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "plugins", :force => true do |t|
    t.string   "name"
    t.string   "version"
    t.string   "family"
    t.string   "cve"
    t.string   "bugtraq"
    t.string   "category"
    t.string   "risk"
    t.string   "summary"
    t.integer  "vulnerabilities_count", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scans", :force => true do |t|
    t.string   "name"
    t.integer  "hosts_count", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subnets", :force => true do |t|
    t.string   "name"
    t.integer  "lowest_ip_address"
    t.integer  "highest_ip_address"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vulnerabilities", :force => true do |t|
    t.string   "protocol"
    t.integer  "port"
    t.string   "service"
    t.text     "data"
    t.integer  "plugin_id"
    t.integer  "host_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
