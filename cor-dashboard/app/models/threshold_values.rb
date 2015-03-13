class ThresholdValues < ActiveRecord::Base

	attr_accessible :patient_id, :bo_perc, :systolic_bp, :diastolic_bp, :heart_rate, :heart_rate_variability, :weight, :hydration, :created_date
	belongs_to :patient
end
