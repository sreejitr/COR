class CreateBloodPressureReadings < ActiveRecord::Migration
  def change
    create_table :blood_pressure_readings do |t|
      t.integer :patient_id
      t.integer :bp_sensor_id
      t.integer :systolic_bp
      t.integer :diastolic_bp
      t.datetime :reading_time
      t.datetime :created_date

      t.timestamps
    end
  end
end
