class AddOptimizations < ActiveRecord::Migration
  def self.up
    add_column :plugin_severities, :severity_modified, :boolean, :default => false

    add_column :vulnerabilities, :severity, :integer
    add_column :vulnerabilities, :severity_modified, :boolean, :default => false

    add_column :hosts, :severity, :integer, :default => nil
  end

  def self.down
    remove_column :plugin_severities, :severity_modified

    remove_column :vulnerabilities, :severity
    remove_column :vulnerabilities, :severity_modified

    remove_column :hosts, :severity
  end
end
