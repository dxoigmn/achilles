class AddOptimizations < ActiveRecord::Migration
  def self.up
    add_column :vulnerabilities, :severity, :integer, :null => true, :default => nil
    add_column :vulnerabilities, :severity_modified, :boolean, :default => false
    
    Vulnerability.reset_column_information
    Vulnerability.find(:all).each do |vulnerability|
      vulnerability.severity          = vulnerability.plugin.severity(vulnerability.host.location)
      vulnerability.severity_modified = false
      vulnerability.save!
    end

    add_column :hosts, :severity, :integer, :default => nil

    Host.reset_column_information
    Host.find(:all).each do |host|
      host.severity = host.vulnerabilities.map(&:severity).max
      host.save!
    end
  end

  def self.down
    remove_column :vulnerabilities, :severity
    remove_column :vulnerabilities, :severity_modified
    
    remove_column :hosts, :severity
  end
end
