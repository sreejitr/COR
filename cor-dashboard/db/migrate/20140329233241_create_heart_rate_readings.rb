class CreateHeartRateReadings < ActiveRecord::Migration
  def change
    create_table :heart_rate_readings do |t|
      t.integer :patient_id
      t.integer :hr_sensor_id
      t.float :heart_rate
      t.float :heart_rate_variability
      t.datetime :reading_time

      t.timestamps
    end
  end
end
