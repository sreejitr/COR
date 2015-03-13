class CreateEmas < ActiveRecord::Migration
  def change
    create_table :emas do |t|
      t.integer :patient_id
      t.float :temperature
      t.string :sodium_level
      t.string :quality_of_sleep
      t.datetime :reading_time
      t.datetime :created_date

      t.timestamps
    end
  end
end
