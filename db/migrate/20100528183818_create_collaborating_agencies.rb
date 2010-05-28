class CreateCollaboratingAgencies < ActiveRecord::Migration
  def self.up
    create_table :collaborating_agencies do |t|
      t.string :name
      t.string :abbrev

      t.timestamps
    end
  end

  def self.down
    drop_table :collaborating_agencies
  end
end
