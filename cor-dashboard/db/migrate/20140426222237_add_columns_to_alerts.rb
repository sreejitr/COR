class AddColumnsToAlerts < ActiveRecord::Migration
  def change
  	remove_column :alerts, :resolved
  	add_column :alerts, :resolved_physician, :boolean
  	add_column :alerts, :resolved_patient, :boolean
  	add_column :alerts, :urgent, :boolean

  end
end
