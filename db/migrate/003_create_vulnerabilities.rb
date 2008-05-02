class CreateVulnerabilities < ActiveRecord::Migration
  def self.up
    create_table :vulnerabilities do |t|
      t.string :port
      t.text :data
      t.integer :plugin_id
      t.integer :host_id

      t.timestamps
    end
  end

  def self.down
    drop_table :vulnerabilities
  end
end
