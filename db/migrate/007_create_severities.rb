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
  end

  def self.down
    drop_table :severities
    drop_table :plugin_severities
  end
end
