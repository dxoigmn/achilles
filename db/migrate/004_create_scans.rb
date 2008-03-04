class CreateScans < ActiveRecord::Migration
  def self.up
    create_table :scans do |t|
      t.string :name
      t.datetime :start
      t.text :output
      t.string :state
      t.integer :hosts_count, :default => 0
      t.integer :location_id
      t.timestamps
    end
    
    add_column :hosts, :scan_id, :integer
  end

  def self.down
    drop_table :scans
    
    remove_column :hosts, :scan_id, :integer
  end
end
