class PhysicianController < ApplicationController

	respond_to :html, :js

	def roster	
		@physician = Physician.take
		@patients = @physician.patients
        @borders = {}
        @patients.each do |patient|            
            if patient.alerts.exists?({resolved_physician: false, urgent: true})           
                @borders[patient.id] = 'critical'
            elsif patient.alerts.exists?({resolved_physician: false, urgent: false})
                 @borders[patient.id] = 'warning'               
            end
        end
	end 

	def critical_patients
		
	end

	def alerts
    @alerts = {}
    @physician = Physician.take
    @patients = @physician.patients
    @patients.each do |patient|
      @alerts[patient.id] = patient.scanForAlerts
    end
	end

	def patients
		
	end

	def settings
		
	end

	def summary
		@physician = Physician.take
		@patient = Patient.find(params[:id])
		@bundle = {}
		@bundle[:blood_oxygen] = @patient.blood_oxygen
    @bundle[:heart_rate] = @patient.heart_rate
		@bundle[:weight] = @patient.weight
		@bundle[:sodium] = @patient.sodium
		@bundle[:blood_pressure] = @patient.blood_pressure
    @exercise_log = @patient.activity_log[:exercise]

    @borders = {}
    if @patient.alerts.exists?({resolved_physician: false, urgent: true, metric_name: "blood oxygen"})
      @borders[:blood_oxygen] = 'critical'
    elsif @patient.alerts.exists?({resolved_physician: false, urgent: false, metric_name: "blood oxygen"})
      @borders[:blood_oxygen] = 'warning'
    end

    if @patient.alerts.exists?({resolved_physician: false, urgent: true, metric_name: "blood pressure"})
      @borders[:blood_pressure] = 'critical'
    elsif @patient.alerts.exists?({resolved_physician: false, urgent: false, metric_name: "blood pressure"})
      @borders[:blood_pressure] = 'warning'
    end

    if @patient.alerts.exists?({resolved_physician: false, urgent: true, metric_name: "heart rate"})
      @borders[:heart_rate] = 'critical'
    elsif @patient.alerts.exists?({resolved_physician: false, urgent: false, metric_name: "heart rate"})
      @borders[:heart_rate] = 'warning'
    end

    if @patient.alerts.exists?({resolved_physician: false, urgent: true, metric_name: "weight"})
      @borders[:weight] = 'critical'
    elsif @patient.alerts.exists?({resolved_physician: false, urgent: false, metric_name: "weight"})
      @borders[:weight] = 'warning'
    end

    if @patient.alerts.exists?({resolved_physician: false, urgent: true, metric_name: "sodium"})
      @borders[:sodium] = 'critical'
    elsif @patient.alerts.exists?({resolved_physician: false, urgent: false, metric_name: "sodium"})
      @borders[:sodium] = 'warning'
    end
	end

	def detail
        @values = {}
        @metric = params[:metric]
        @physician = Physician.take
        #@patients = @physician.patients
        @patient = Patient.find(params[:patientId])
        # last_week
        bundle = @patient.weight_last_week
        @threshold_wt = bundle[:threshold]
        @values_wt = bundle[:values]
        bundle = @patient.blood_oxygen
        @threshold_bo = bundle[:threshold]
        @values_bo = bundle[:values]
        bundle = @patient.heart_rate_last_week
        @threshold_hr = bundle[:threshold]
        @values_hr = bundle[:values]
        bundle = @patient.blood_pressure_last_week
        @threshold_bp = bundle[:threshold]
        @values_bp = bundle[:values]
        bundle = @patient.sodium
        @threshold_so = bundle[:threshold]
        @values_so = bundle[:values]
        @exercise_log = @patient.activity_log[:exercise]

        # last_2_weeks
        bundle = @patient.weight
        @threshold_wt2w = bundle[:threshold]
        @values_wt2w = bundle[:values]
        bundle = @patient.blood_oxygen_last_2_weeks
        @threshold_bo2w = bundle[:threshold]
        @values_bo2w = bundle[:values]
        bundle = @patient.heart_rate_last_2_weeks
        @threshold_hr2w = bundle[:threshold]
        @values_hr2w = bundle[:values]
        bundle = @patient.blood_pressure_last_2_weeks
        @threshold_bp2w = bundle[:threshold]
        @values_bp2w = bundle[:values]
        bundle = @patient.sodium_last_2_weeks
        @threshold_so2w = bundle[:threshold]
        @values_so2w = bundle[:values]
        @exercise_log_2w = @patient.activity_log_last_2_weeks[:exercise]

        # last_month
        bundle = @patient.weight_last_month
        @threshold_wtm = bundle[:threshold]
        @values_wtm = bundle[:values]
        bundle = @patient.blood_oxygen_last_month
        @threshold_bom = bundle[:threshold]
        @values_bom = bundle[:values]
        bundle = @patient.heart_rate_last_month
        @threshold_hrm = bundle[:threshold]
        @values_hrm = bundle[:values]
        bundle = @patient.blood_pressure_last_month
        @threshold_bpm = bundle[:threshold]
        @values_bpm = bundle[:values]
        bundle = @patient.sodium_last_month
        @threshold_som = bundle[:threshold]
        @values_som = bundle[:values]
        @exercise_log_m = @patient.activity_log_last_month[:exercise]

        # last_three_months
        bundle = @patient.weight_last_three_months
        @threshold_wt3m = bundle[:threshold]
        @values_wt3m = bundle[:values]
        bundle = @patient.blood_oxygen_last_three_months
        @threshold_bo3m = bundle[:threshold]
        @values_bo3m = bundle[:values]
        bundle = @patient.heart_rate_last_three_months
        @threshold_hr3m = bundle[:threshold]
        @values_hr3m = bundle[:values]
        bundle = @patient.blood_pressure_last_three_months
        @threshold_bp3m = bundle[:threshold]
        @values_bp3m = bundle[:values]
        bundle = @patient.sodium_last_three_months
        @threshold_so3m = bundle[:threshold]
        @values_so3m = bundle[:values]

        # last_six_months
        bundle = @patient.weight_last_six_months
        @threshold_wt6m = bundle[:threshold]
        @values_wt6m = bundle[:values]
        bundle = @patient.blood_oxygen_last_six_months
        @threshold_bo6m = bundle[:threshold]
        @values_bo6m = bundle[:values]
        bundle = @patient.heart_rate_last_six_months
        @threshold_hr6m = bundle[:threshold]
        @values_hr6m = bundle[:values]
        bundle = @patient.blood_pressure_last_six_months
        @threshold_bp6m = bundle[:threshold]
        @values_bp6m = bundle[:values]
        bundle = @patient.sodium_last_six_months
        @threshold_so6m = bundle[:threshold]
        @values_so6m = bundle[:values]

        # last_year
        bundle = @patient.weight_last_year
        @threshold_wty = bundle[:threshold]
        @values_wty = bundle[:values]
        bundle = @patient.blood_oxygen_last_year
        @threshold_boy = bundle[:threshold]
        @values_boy = bundle[:values]
        bundle = @patient.heart_rate_last_year
        @threshold_hry = bundle[:threshold]
        @values_hry = bundle[:values]
        bundle = @patient.blood_pressure_last_year
        @threshold_bpy = bundle[:threshold]
        @values_bpy = bundle[:values]
        bundle = @patient.sodium_last_year
        @threshold_soy = bundle[:threshold]
        @values_soy = bundle[:values]

    end
end