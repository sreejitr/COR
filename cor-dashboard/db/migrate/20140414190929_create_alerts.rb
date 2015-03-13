class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.boolean :resolved
      t.string :text
      t.integer :reading_id
      t.integer :patient_id

      t.timestamps
    end
  end
end
