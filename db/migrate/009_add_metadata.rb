class AddMetadata < ActiveRecord::Migration
  def self.up
    add_column :hosts, :description, :text, :null => false, :default => ""
    add_column :hosts, :evaluation, :text, :null => false, :default => ""
    add_column :hosts, :remediation, :text, :null => false, :default => ""
    
    add_column :plugins, :description, :text, :null => false, :default => ""
    add_column :plugins, :evaluation, :text, :null => false, :default => ""
    add_column :plugins, :remediation, :text, :null => false, :default => ""
    add_column :plugins, :visible, :boolean, :null => false, :default => true
  end

  def self.down
    add_column :hosts, :description
    add_column :hosts, :evaluation
    add_column :hosts, :remediation
    
    add_column :plugins, :description
    add_column :plugins, :evaluation
    add_column :plugins, :remediation
    add_column :plugins, :visible
  end
end
