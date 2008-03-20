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

ActiveRecord::Schema.define(:version => 9) do

  create_table "classifications", :force => true do |t|
    t.string "name"
  end

  create_table "families", :force => true do |t|
    t.string "name"
  end

  create_table "hosts", :force => true do |t|
    t.string   "name"
    t.integer  "ip",                    :limit => 10, :default => 0, :null => false
    t.datetime "scan_start"
    t.datetime "scan_end"
    t.integer  "vulnerabilities_count",               :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "location_id"
    t.integer  "scan_id"
    t.text     "description"
    t.text     "evaluation"
    t.text     "remediation"
  end

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.integer  "hosts_count", :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations_scans", :id => false, :force => true do |t|
    t.integer "location_id"
    t.integer "scan_id"
  end

  create_table "plugin_classifications", :id => false, :force => true do |t|
    t.integer "risk_id"
    t.integer "family_id"
    t.integer "classification_id"
  end

  create_table "plugin_severities", :force => true do |t|
    t.integer  "plugin_id"
    t.integer  "location_id"
    t.integer  "severity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "plugins", :force => true do |t|
    t.string   "name"
    t.string   "version"
    t.string   "cve"
    t.string   "bugtraq"
    t.string   "category"
    t.string   "summary"
    t.integer  "family_id"
    t.integer  "risk_id"
    t.integer  "vulnerabilities_count", :default => 0,    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "classification_id"
    t.text     "description"
    t.text     "evaluation"
    t.text     "remediation"
    t.boolean  "visible",               :default => true, :null => false
  end

  create_table "risks", :force => true do |t|
    t.string "name"
  end

  create_table "scans", :force => true do |t|
    t.string   "name"
    t.datetime "starts_at"
    t.text     "output"
    t.string   "state"
    t.integer  "hosts_count", :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "severities", :force => true do |t|
    t.integer  "location_id"
    t.integer  "classification_id"
    t.integer  "severity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "statuses", :force => true do |t|
    t.string  "name"
    t.boolean "default", :default => false, :null => false
  end

  create_table "subnets", :force => true do |t|
    t.string   "name"
    t.integer  "lowest_ip_address",  :limit => 10, :default => 0, :null => false
    t.integer  "highest_ip_address", :limit => 10, :default => 0, :null => false
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vulnerabilities", :force => true do |t|
    t.string   "protocol"
    t.integer  "port",        :default => 0, :null => false
    t.string   "service"
    t.text     "data"
    t.integer  "plugin_id"
    t.integer  "host_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "severity"
    t.integer  "status_id"
    t.text     "description"
    t.text     "evaluation"
    t.text     "remediation"
    t.boolean  "visible"
  end

end
