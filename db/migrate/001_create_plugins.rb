class CreatePlugins < ActiveRecord::Migration
  def self.up
    create_table :families do |t|
      t.string :name, :null => false, :default => ''
    end
    
    create_table :risks do |t|
      t.string :name, :null => false, :default => ''
    end

    create_table :plugins do |t|
      t.string :name, :null => false, :default => ''
      t.string :version, :null => false, :default => ''
      t.string :cve, :null => false, :default => ''
      t.string :bugtraq, :null => false, :default => ''
      t.string :category, :null => false, :default => ''
      t.string :summary, :null => false, :default => ''
      t.integer :family_id
      t.integer :risk_id
      t.integer :vulnerabilities_count, :null => false, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :families
    drop_table :risks
    drop_table :plugins
  end
end
