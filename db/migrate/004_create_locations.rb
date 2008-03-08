class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.string :name
      t.integer :hosts_count, :default => 0
      t.timestamps
    end
    
    create_table :subnets do |t|
      t.string :name
      t.integer :lowest_ip_address
      t.integer :highest_ip_address
      t.integer :location_id

      t.timestamps
    end
    
    add_column :hosts, :location_id, :integer, :default => 0
  end

  def self.down
    drop_table :locations
    drop_table :subnets

    remove_column :hosts, :location_id
  end
end
