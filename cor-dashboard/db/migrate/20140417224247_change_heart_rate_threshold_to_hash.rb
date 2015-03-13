class ChangeHeartRateThresholdToHash < ActiveRecord::Migration
  def change
  	 	
    change_column :threshold_values, :bo_perc, :float
    change_column :threshold_values, :systolic_bp, :string
    change_column :threshold_values, :diastolic_bp, :string
    change_column :threshold_values, :heart_rate, :string
    change_column :threshold_values, :heart_rate_variability, :float
    change_column :threshold_values, :weight, :string
    change_column :threshold_values, :hydration, :float
  end
end
