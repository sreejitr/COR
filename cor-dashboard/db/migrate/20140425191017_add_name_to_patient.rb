class AddNameToPatient < ActiveRecord::Migration
  def change
  	add_column :patients, :name, :string  	
  end
end
