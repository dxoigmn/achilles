class CreateHosts < ActiveRecord::Migration
  def self.up
    create_table :hosts do |t|
      t.string :name, :null => false, :default => ''
      t.integer :ip, :null => false, :default => 0
      t.datetime :scan_start, :null => false, :default => ''
      t.datetime :scan_end, :null => false, :default => ''
      t.integer :vulnerabilities_count, :null => false, :default => 0
      
      t.timestamps
    end
  end

  def self.down
    drop_table :hosts
  end
end
