class CreateStatuses < ActiveRecord::Migration
  def self.up
    create_table :statuses do |t|
      t.string :name
      t.boolean :default, :null => false, :default => false
    end

    add_column :vulnerabilities, :status_id, :integer
  end

  def self.down
    drop_table :statuses

    remove_column :vulnerabilities, :status_id
  end
end
