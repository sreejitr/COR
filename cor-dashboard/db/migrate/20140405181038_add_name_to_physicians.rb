class AddNameToPhysicians < ActiveRecord::Migration
  def change
  	add_column :physicians, :name, :string
  end
end
