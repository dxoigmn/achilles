class CreatePlugins < ActiveRecord::Migration
  def self.up
    create_table :plugins do |t|
      t.string :name
      t.string :version
      t.string :family
      t.string :cve
      t.string :bugtraq
      t.string :category
      t.string :risk
      t.string :summary
      t.integer :vulnerabilities_count, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :plugins
  end
end
