class CreateStatuses < ActiveRecord::Migration
  def self.up
    create_table :statuses do |t|
      t.string :name, :null => false, :default => ''
      t.boolean :default, :null => false, :default => false
    end
    
    add_column :plugins, :status_id, :integer
  end

  def self.down
    drop_table :statuses
    
    remove_column :plugins, :status_id
  end
end
