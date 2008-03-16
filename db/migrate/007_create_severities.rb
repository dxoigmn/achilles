class CreateSeverities < ActiveRecord::Migration
  def self.up
    create_table :severities do |t|
      t.string :name
      t.integer :value, :null => false, :default => 0
    end

    create_table :plugin_severities do |t|
      t.integer :plugin_id
      t.integer :location_id
      t.integer :severity_id

      t.timestamps
    end

    create_table :vulnerability_severities do |t|
      t.integer :location_id
      t.integer :classification_id
      t.integer :severity_id

      t.timestamps
    end
    
    add_column :vulnerabilities, :severity_id, :integer
  end

  def self.down
    drop_table :severities
    drop_table :plugin_severities
    drop_table :vulnerability_severities

    remove_column :vulnerabilities, :severity_id
  end
end
