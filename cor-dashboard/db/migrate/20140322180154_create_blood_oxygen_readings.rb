class CreateBloodOxygenReadings < ActiveRecord::Migration
  def change
    create_table :blood_oxygen_readings do |t|

      t.timestamps
    end
  end
end
