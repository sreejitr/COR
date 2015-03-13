namespace :db do
  desc "Erase and fill database"
  task :random => :environment do
  
    [Physician, Patient, BloodOxygenReading, HeartRateReading, WeightReading, ThresholdValues, Ema, Activity, Alert].each(&:delete_all)

    physician = Physician.create(:name => "Dr. Smith")
    names = ["Bob", "Adam", "Jay", "Abhishek", "Greg", "Brandon", "Harvey", "Bruce", "Tyler", "Michael",
    					"Veronica", "Sandy", "Rita", "Ashe", "Wanda", "Jisha","Sreejita","Abby","Ranika","Crystal"]
    20.times do
    	patient = Patient.create(:physician_id => physician.id, :name => names.sample, :phone_number => Random.new.rand(1000000000 .. 9999999999))

			90.times do |i|
				Ema.create(:patient_id => patient.id, :sodium_level => ["High", "Low", "Medium"].sample, :reading_time => Time.now-i.days) 
				
				BloodOxygenReading.create(:patient_id => patient.id, :bo_sensor_id => 123456789, 
																	:bo_perc => Random.new.rand(85.0..100.0), :reading_time => Time.now-i.days)   
				
				BloodPressureReading.create(:patient_id => patient.id, :bp_sensor_id => 123456789, 
																		:systolic_bp => Random.new.rand(100..120), 
																		:diastolic_bp => Random.new.rand(70..80), :reading_time => Time.now-i.days)	
				
				HeartRateReading.create(:patient_id => patient.id, :hr_sensor_id => 123456789, 
																:heart_rate => Random.new.rand(100.0..120.0), :heart_rate_variability => Random.new.rand(900..1200), :reading_time => Time.now-i.days)
				
				WeightReading.create(:patient_id => patient.id, :bo_sensor_id => 123456789, :weight => Random.new.rand(114.0..120.0).round(3), :reading_time => Time.now-i.days)
				
				Activity.create(:patient_id => patient.id, 
				              :minutes_asleep => Random.new.rand(240..540), 
				              :number_of_awakenings => Random.new.rand(1..10),
				              :sleep_efficiency => Random.new.rand(0.4..1.0), 
				              :steps => Random.new.rand(500..10000), 
				              :sedentary_minutes => Random.new.rand(600..800), 
				              :lightly_active_minutes => Random.new.rand(100..300),
				              :fairly_active_minutes => Random.new.rand(100..200), 
				              :very_active_minutes => Random.new.rand(0..60),
				              :date => Time.now-i.days)		

		    ThresholdValues.create(:patient_id =>patient.id, 
		        :bo_perc => 90, 
		        :weight => {weight: 5, time: 7}.to_s,
		        :heart_rate => {high: 140, low: 50}.to_s, 
		        :heart_rate_variability => 0.5, 
		        :systolic_bp => {high: 150, low: 90}.to_s, 
		        :diastolic_bp => {high: 90, low: 60}.to_s)	            
		    end   
		  end
end

def create_random_patient
																									
	end   
end

