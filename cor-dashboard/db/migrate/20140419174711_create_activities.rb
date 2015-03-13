class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :patient_id
      t.datetime :date
      t.integer :minutes_asleep
      t.integer :number_of_awakenings
      t.float :sleep_efficiency
      t.integer :steps
      t.integer :sedentary_minutes
      t.integer :lightly_active_minutes
      t.integer :fairly_active_minutes
      t.integer :very_active_minutes

      t.timestamps
    end
  end
end
