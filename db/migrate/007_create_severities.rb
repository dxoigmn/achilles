class CreateSeverities < ActiveRecord::Migration
  def self.up
    create_table :severities do |t|
      t.integer :location_id
      t.integer :classification_id
      t.integer :severity

      t.timestamps
    end

    create_table :plugin_severities do |t|
      t.integer :plugin_id
      t.integer :location_id
      t.integer :severity

      t.timestamps
    end
    
    add_column :vulnerabilities, :severity, :integer, :null => true, :default => nil
  end

  def self.down
    drop_table :severities
    drop_table :plugin_severities

    remove_column :vulnerabilities, :severity
  end
end
