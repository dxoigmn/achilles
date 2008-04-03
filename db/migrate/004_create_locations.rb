class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.string :name
      t.integer :hosts_count, :null => false, :default => 0
      t.timestamps
    end
    
    create_table :subnets do |t|
      t.string :name
      t.column :lowest_ip_address, 'integer unsigned', :null => false, :default => NetAddr.ip_to_i('0.0.0.0')
      t.column :highest_ip_address, 'integer unsigned', :null => false, :default => NetAddr.ip_to_i('255.255.255.255')
      t.integer :location_id

      t.timestamps
    end
    
    add_column :hosts, :location_id, :integer
  end

  def self.down
    drop_table :locations
    drop_table :subnets

    remove_column :hosts, :location_id
  end
end
