class AddDescriptionToCriteria < ActiveRecord::Migration
  def self.up
    add_column :criteria, :description, :text
  end

  def self.down
    remove_column :criteria, :description
  end
end
