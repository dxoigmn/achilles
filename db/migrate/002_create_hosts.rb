class CreateHosts < ActiveRecord::Migration
  def self.up
    create_table :hosts do |t|
      t.string :name
      t.column :ip, 'integer unsigned', :null => false, :default => NetAddr.ip_to_i('0.0.0.0')
      t.datetime :scan_start
      t.datetime :scan_end
      t.integer :vulnerabilities_count, :null => false, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :hosts
  end
end
