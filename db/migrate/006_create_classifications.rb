class CreateClassifications < ActiveRecord::Migration
  def self.up
    create_table :classifications do |t|
      t.string :name
    end
    
    create_table :plugin_classifications, :id => false do |t|
      t.integer :risk_id
      t.integer :family_id
      t.integer :classification_id
    end
    
    add_column :plugins, :classification_id, :integer
  end

  def self.down
    drop_table :classifications
    drop_table :plugin_classifications
    
    remove_column :plugins, :classification_id
  end
end
