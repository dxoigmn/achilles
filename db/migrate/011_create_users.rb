class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.integer :page_size, :default => 15
      t.timestamps
    end

    create_table :locations_users, :id => false do |t|
      t.integer :user_id
      t.integer :location_id
    end
  end

  def self.down
    drop_table :users
    drop_table :locations_users
  end
end
