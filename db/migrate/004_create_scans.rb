class CreateScans < ActiveRecord::Migration
  def self.up
    create_table :scans do |t|
      t.string :name
      t.integer :hosts_count, :default => 0
      t.timestamps
    end
    
    add_column :hosts, :scan_id, :integer
  end

  def self.down
    drop_table :scans
    
    remove_column :hosts, :scan_id, :integer
  end
end
