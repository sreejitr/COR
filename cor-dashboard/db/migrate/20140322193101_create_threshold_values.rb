class CreateThresholdValues < ActiveRecord::Migration
  def change
    create_table :threshold_values do |t|

      t.timestamps
    end
  end
end
