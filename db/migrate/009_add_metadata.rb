class AddMetadata < ActiveRecord::Migration
  def self.up
    add_column :hosts, :description, :text
    add_column :hosts, :evaluation, :text
    add_column :hosts, :remediation, :text
    
    add_column :plugins, :description, :text
    add_column :plugins, :evaluation, :text
    add_column :plugins, :remediation, :text
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
