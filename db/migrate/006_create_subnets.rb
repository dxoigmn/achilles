class CreateSubnets < ActiveRecord::Migration
  def self.up
    create_table :subnets do |t|
      t.string :name
      t.integer :lowest_ip_address
      t.integer :highest_ip_address
      t.integer :location_id

      t.timestamps
    end
  end

  def self.down
    drop_table :subnets
  end
end
