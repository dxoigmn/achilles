class CreateVulnerabilities < ActiveRecord::Migration
  def self.up
    create_table :vulnerabilities do |t|
      t.string :protocol, :null => false, :default => ''
      t.integer :port, :null => false, :default => 0
      t.string :service, :null => false, :default => ''
      t.text :data, :null => false, :default => ''
      t.integer :plugin_id
      t.integer :host_id

      t.timestamps
    end
  end

  def self.down
    drop_table :vulnerabilities
  end
end
