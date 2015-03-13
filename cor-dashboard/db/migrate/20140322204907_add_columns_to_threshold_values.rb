class AddColumnsToThresholdValues < ActiveRecord::Migration
  def change
    add_column :threshold_values, :patient_id, :integer
    add_column :threshold_values, :bo_perc, :float
    add_column :threshold_values, :systolic_bp, :integer
    add_column :threshold_values, :diastolic_bp, :integer
    add_column :threshold_values, :heart_rate, :float
    add_column :threshold_values, :heart_rate_variability, :float
    add_column :threshold_values, :weight, :float
    add_column :threshold_values, :hydration, :float
  end
end
