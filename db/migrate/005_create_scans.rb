class CreateScans < ActiveRecord::Migration
  def self.up
    create_table :scans do |t|
      t.string :name, :null => false, :default => ''
      t.datetime :starts_at, :null => false, :default => ''
      t.text :output, :null => false, :default => ''
      t.string :state, :null => false, :default => ''
      t.integer :hosts_count, :null => false, :default => 0
      t.integer :location_id
      t.timestamps
    end
    
    create_table :locations_scans, :id => false do |t|
      t.integer :location_id
      t.integer :scan_id
    end
    
    add_column :hosts, :scan_id, :integer
  end

  def self.down
    drop_table :scans
    drop_table :locations_scans
    
    remove_column :hosts, :scan_id, :integer
  end
end
