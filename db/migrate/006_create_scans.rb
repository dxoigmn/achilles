class CreateScans < ActiveRecord::Migration
  def self.up
    create_table :scans do |t|
      t.string :name
      t.datetime :starts_at
      t.text :output, :default => ''
      t.string :state
      t.integer :hosts_count, :default => 0
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
