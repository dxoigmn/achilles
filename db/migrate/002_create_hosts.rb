class CreateHosts < ActiveRecord::Migration
  def self.up
    create_table :hosts do |t|
      t.string :name
      t.integer :ip
      t.datetime :scan_start
      t.datetime :scan_end

      t.timestamps
    end
  end

  def self.down
    drop_table :hosts
  end
end
