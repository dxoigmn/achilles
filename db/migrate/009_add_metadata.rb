class AddMetadata < ActiveRecord::Migration
  def self.up
    add_column :hosts, :description, :text
    add_column :hosts, :evaluation, :text
    add_column :hosts, :remediation, :text

    add_column :vulnerabilities, :description, :text
    add_column :vulnerabilities, :evaluation, :text
    add_column :vulnerabilities, :remediation, :text
    add_column :vulnerabilities, :visible, :boolean, :null => true, :default => nil
    
    add_column :plugins, :description, :text
    add_column :plugins, :evaluation, :text
    add_column :plugins, :remediation, :text
    add_column :plugins, :visible, :boolean, :null => false, :default => true
  end

  def self.down
    remove_column :hosts, :description
    remove_column :hosts, :evaluation
    remove_column :hosts, :remediation

    remove_column :vulnerabilities, :description
    remove_column :vulnerabilities, :evaluation
    remove_column :vulnerabilities, :remediation

    remove_column :plugins, :description
    remove_column :plugins, :evaluation
    remove_column :plugins, :remediation
    remove_column :plugins, :visible
  end
end
