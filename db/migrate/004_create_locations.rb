class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.string :name

      t.timestamps
    end
    
    add_column :hosts, :location_id, :integer, :default => 0
  end

  def self.down
    drop_table :locations

    remove_column :hosts, :location_id
  end
end
