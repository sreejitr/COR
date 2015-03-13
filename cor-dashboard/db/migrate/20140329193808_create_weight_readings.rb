class CreateWeightReadings < ActiveRecord::Migration
  def change
    create_table :weight_readings do |t|
      t.integer :patient_id
      t.float :weight
      t.float :hydration
      t.datetime :reading_time
      t.datetime :created_date
      t.integer :weight_monitor_id

      t.timestamps
    end
  end
end
