class AddColumnsToBloodOxygenReading < ActiveRecord::Migration
  def change
    add_column :blood_oxygen_readings, :patient_id, :integer
    add_column :blood_oxygen_readings, :bo_sensor_id, :integer
    add_column :blood_oxygen_readings, :bo_perc, :float
    add_column :blood_oxygen_readings, :reading_time, :datetime
  end
end
