class CreatePlugins < ActiveRecord::Migration
  def self.up
    create_table :families do |t|
      t.string :name
    end

    create_table :risks do |t|
      t.string :name
    end

    create_table :plugins do |t|
      t.string :name
      t.string :version
      t.string :cve
      t.string :bugtraq
      t.string :category
      t.string :summary
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
