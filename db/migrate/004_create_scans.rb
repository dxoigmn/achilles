class CreateScans < ActiveRecord::Migration
  def self.up
    create_table :scans do |t|
      t.string :name

      t.timestamps
    end
    
    add_column :hosts, :scan_id, :integer
  end

  def self.down
    drop_table :scans
    
    remove_column :hosts, :scan_id, :integer
  end
end
