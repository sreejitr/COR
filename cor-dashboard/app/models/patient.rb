class Patient < ActiveRecord::Base

    attr_accessible :id, :physician_id, :name, :phone_number
    
		belongs_to :physician

    has_many :blood_oxygen_readings
    has_many :heart_rate_readings
    has_many :weight_readings
    has_many :blood_pressure_readings   
    has_many :emas
    has_many :alerts
    has_many :activities
    has_one :threshold_values

    if Rails.env.production?
      self.table_name = "patient_info"
      alias_attribute :name, :patient_name
      alias_attribute :id, :patient_id
    end

    def health_summary      
      # # Basic premise: Average the readings for last two weeks // Read most recent reading
      # # Compare to an ideal "green" value if possible. 
      # # Value to send to summary graph is mapped from its range to appropriate graph range

      #Weight Summary 
      wt_thresh = eval(threshold_values.weight)
      wt_over_interval = weight_readings.last_n_days(wt_thresh[:time]).map {|r| r.weight}
      wt_change = wt_over_interval.max - wt_over_interval.min
      if wt_change >= wt_thresh[:weight] # I'm hardcoding the max weight gain we expect
        wt_summ = map(wt_change, wt_thresh[:weight], 10, 5, 6 )
      else # I'm also hardcoding the max weight loss we expect
        wt_summ = map(wt_change, -10, wt_thresh[:weight], 2.5, 3.5)
      end    

      #Blood Oxygen Summary  

      bo_current = blood_oxygen_readings.latest.bo_perc
      if bo_current > threshold_values.bo_perc # Map good values to the 2.5-3 zone
        bo_summ = map(bo_current, threshold_values.bo_perc, 100.0, 2.5, 3)
      else # Map bad values to the 0-2 zone
        bo_summ = map(bo_current, 60.0, threshold_values.bo_perc, 0, 1.5)
      end  
      
      #Blood Pressure Summary

        # The value would be perfectly in the green zone if it was between the high and low thresholds
      green_sys = avg(eval(threshold_values.systolic_bp)[:high] , eval(threshold_values.systolic_bp)[:low]).to_f
      green_dia = avg(eval(threshold_values.diastolic_bp)[:high], eval(threshold_values.diastolic_bp)[:low]).to_f
     
      bp_sys_current = blood_pressure_readings.latest.systolic_bp.to_f
      bp_dia_current = blood_pressure_readings.latest.diastolic_bp.to_f
      
      bp_sys_change = change(bp_sys_current, green_sys)
      bp_dia_change = change(bp_dia_current, green_dia)

        # Whichever change is bigger (because we consider the "worst" bp value)      
      bp_change = max(bp_sys_change, bp_dia_change)

      bp_summ = map(bp_change, -1.0, 1.0, 0.5, 5.5)

      #Heart Rate Summary
      green_hr = avg(eval(threshold_values.heart_rate)[:high], eval(threshold_values.heart_rate)[:low])  
     
      hr_curr = heart_rate_readings.latest.heart_rate 
      hr_high = eval(threshold_values.heart_rate)[:high]
      hr_low = eval(threshold_values.heart_rate)[:low]
     
      if(hr_curr > hr_low && hr_curr < hr_high)
        hr_summ = map(hr_curr, hr_low, hr_high, 2.5, 3.5)
      elsif(hr_curr > hr_high)
        hr_summ = map(hr_curr, hr_high, 200, 4.5, 5.5)
      elsif (hr_curr < hr_low)
        hr_summ = map(hr_curr, 0, hr_low, 0, 1.5)
      end

      #Sodium Summary
     
      so_curr = sodiumStringToInt(emas.latest.sodium_level)
      
      so_summ = map(so_curr, 1,3, 3, 5) # Low is best, so it's in the green. Medium is on the border, High in the red
      
      # The map function converts a value from one range to another (see at foot of file)     
      return {weight: wt_summ, 
              heart_rate: hr_summ, 
              blood_oxygen: bo_summ,                       
              blood_pressure: bp_summ,              
              sodium: so_summ}
    end

    #Blood oxygen
    def blood_oxygen
      return {threshold: threshold_values.bo_perc,
              values: blood_oxygen_readings.last_week.map {|r| [r.reading_time.utc.to_i*1000, r.bo_perc] }}
    end

    def blood_oxygen_last_2_weeks
      return {threshold: threshold_values.bo_perc,
              values: blood_oxygen_readings.last_2_weeks.map {|r| [r.reading_time.utc.to_i*1000, r.bo_perc] }}
    end

    def blood_oxygen_last_month
      return {threshold: threshold_values.bo_perc,
              values: blood_oxygen_readings.last_month.map {|r| [r.reading_time.utc.to_i*1000, r.bo_perc] }}
    end

    def blood_oxygen_last_three_months
      return {threshold: threshold_values.bo_perc,
              values: blood_oxygen_readings.last_three_months.map {|r| [r.reading_time.utc.to_i*1000, r.bo_perc] }}
    end

    def blood_oxygen_last_six_months
      return {threshold: threshold_values.bo_perc,
              values: blood_oxygen_readings.last_six_months.map {|r| [r.reading_time.utc.to_i*1000, r.bo_perc] }}
    end

    def blood_oxygen_last_year
      return {threshold: threshold_values.bo_perc,
              values: blood_oxygen_readings.last_year.map {|r| [r.reading_time.utc.to_i*1000, r.bo_perc] }}
    end

    #Heart Rate
    def heart_rate    
      r = heart_rate_readings.latest
    	return {threshold: eval(threshold_values.heart_rate), 
      				values: [r.reading_time.utc.to_i*1000, r.heart_rate],
              variability: r.heart_rate_variability }  
    end

    def heart_rate_last_week
      return {threshold: eval(threshold_values.heart_rate),
              values: heart_rate_readings.last_week.map {|r| [r.reading_time.utc.to_i*1000, r.heart_rate] }}
    end


    def heart_rate_last_2_weeks
      return {threshold: eval(threshold_values.heart_rate),
              values: heart_rate_readings.last_2_weeks.map {|r| [r.reading_time.utc.to_i*1000, r.heart_rate] }}
    end

    def heart_rate_last_month
      return {threshold: eval(threshold_values.heart_rate),
              values: heart_rate_readings.last_month.map {|r| [r.reading_time.utc.to_i*1000, r.heart_rate] }}
    end

    def heart_rate_last_three_months
      return {threshold: eval(threshold_values.heart_rate),
              values: heart_rate_readings.last_three_months.map {|r| [r.reading_time.utc.to_i*1000, r.heart_rate] }}
    end

    def heart_rate_last_six_months
      return {threshold: eval(threshold_values.heart_rate),
              values: heart_rate_readings.last_six_months.map {|r| [r.reading_time.utc.to_i*1000, r.heart_rate] }}
    end

    def heart_rate_last_year
      return {threshold: eval(threshold_values.heart_rate),
              values: heart_rate_readings.last_year.map {|r| [r.reading_time.utc.to_i*1000, r.heart_rate] }}
    end
    # Weight
    def weight
      return {threshold: eval(threshold_values.weight),
              values: weight_readings.last_2_weeks.map {|r| [r.reading_time.utc.to_i*1000, r.weight] }}

    end

    def weight_last_week
      return {threshold: eval(threshold_values.weight),
              values: weight_readings.last_week.map {|r| [r.reading_time.utc.to_i*1000, r.weight] }}

    end

    def weight_last_month
      return {threshold: eval(threshold_values.weight),
              values: weight_readings.last_month.map {|r| [r.reading_time.utc.to_i*1000, r.weight] }}

    end

    def weight_last_three_months
      return {threshold: eval(threshold_values.weight),
              values: weight_readings.last_three_months.map {|r| [r.reading_time.utc.to_i*1000, r.weight] }}

    end

    def weight_last_six_months
      return {threshold: eval(threshold_values.weight),
              values: weight_readings.last_six_months.map {|r| [r.reading_time.utc.to_i*1000, r.weight] }}

    end

    def weight_last_year
      return {threshold: eval(threshold_values.weight),
              values: weight_readings.last_year.map {|r| [r.reading_time.utc.to_i*1000, r.weight] }}

    end

    # Sodium

    def sodium
        return {threshold: 0,
                values: emas.last_week.map {|r| [r.reading_time.utc.to_i*1000, sodiumStringToInt(r.sodium_level)] }}
    end

    def sodium_last_2_weeks
      return {threshold: 0,
              values: emas.last_2_weeks.map {|r| [r.reading_time.utc.to_i*1000, sodiumStringToInt(r.sodium_level)] }}
    end

    def sodium_last_month
      return {threshold: 0,
              values: emas.last_month.map {|r| [r.reading_time.utc.to_i*1000, sodiumStringToInt(r.sodium_level)] }}
    end

    def sodium_last_three_months
      return {threshold: 0,
              values: emas.last_three_months.map {|r| [r.reading_time.utc.to_i*1000, sodiumStringToInt(r.sodium_level)] }}
    end

    def sodium_last_six_months
      return {threshold: 0,
              values: emas.last_six_months.map {|r| [r.reading_time.utc.to_i*1000, sodiumStringToInt(r.sodium_level)] }}
    end

    def sodium_last_year
      return {threshold: 0,
              values: emas.last_year.map {|r| [r.reading_time.utc.to_i*1000, sodiumStringToInt(r.sodium_level)] }}
    end

    # Blood Pressure
    def blood_pressure
        r = blood_pressure_readings.latest
        return {threshold: {:systolic => eval(threshold_values.systolic_bp),
                            :diastolic => eval(threshold_values.diastolic_bp)} ,
        values: [r.reading_time.utc.to_i*1000, r.systolic_bp, r.diastolic_bp] }
    end

    def blood_pressure_last_week
      return {threshold: {systolic: eval(threshold_values.systolic_bp),
                          diastolic: eval(threshold_values.diastolic_bp)} ,
              values: {systolic: blood_pressure_readings.last_week.map {|r| [r.reading_time.utc.to_i*1000, r.systolic_bp] },
                        diastolic: blood_pressure_readings.last_week.map {|r| [r.reading_time.utc.to_i*1000, r.diastolic_bp] }} }
    end

    def blood_pressure_last_2_weeks
      return {threshold: {systolic: eval(threshold_values.systolic_bp),
                          diastolic: eval(threshold_values.diastolic_bp)} ,
              values: {systolic: blood_pressure_readings.last_2_weeks.map {|r| [r.reading_time.utc.to_i*1000, r.systolic_bp] },
                       diastolic: blood_pressure_readings.last_2_weeks.map {|r| [r.reading_time.utc.to_i*1000, r.diastolic_bp] }} }
    end

    def blood_pressure_last_month
      return {threshold: {systolic: eval(threshold_values.systolic_bp),
                          diastolic: eval(threshold_values.diastolic_bp)} ,
              values: {systolic: blood_pressure_readings.last_month.map {|r| [r.reading_time.utc.to_i*1000, r.systolic_bp] },
                       diastolic: blood_pressure_readings.last_month.map {|r| [r.reading_time.utc.to_i*1000, r.diastolic_bp] }} }
    end

    def blood_pressure_last_three_months
      return {threshold: {systolic: eval(threshold_values.systolic_bp),
                          diastolic: eval(threshold_values.diastolic_bp)} ,
              values: {systolic: blood_pressure_readings.last_three_months.map {|r| [r.reading_time.utc.to_i*1000, r.systolic_bp] },
                       diastolic: blood_pressure_readings.last_three_months.map {|r| [r.reading_time.utc.to_i*1000, r.diastolic_bp] }} }
    end

    def blood_pressure_last_six_months
      return {threshold: {systolic: eval(threshold_values.systolic_bp),
                          diastolic: eval(threshold_values.diastolic_bp)} ,
              values: {systolic: blood_pressure_readings.last_six_months.map {|r| [r.reading_time.utc.to_i*1000, r.systolic_bp] },
                       diastolic: blood_pressure_readings.last_six_months.map {|r| [r.reading_time.utc.to_i*1000, r.diastolic_bp] }} }
    end

    def blood_pressure_last_year
      return {threshold: {systolic: eval(threshold_values.systolic_bp),
                          diastolic: eval(threshold_values.diastolic_bp)} ,
              values: {systolic: blood_pressure_readings.last_year.map {|r| [r.reading_time.utc.to_i*1000, r.systolic_bp] },
                       diastolic: blood_pressure_readings.last_year.map {|r| [r.reading_time.utc.to_i*1000, r.diastolic_bp] }} }
    end

    def activity_log
      #Package up the data for the activity log page
      return  {exercise: {sedentary: activities.last_week.map {|r| r.sedentary_minutes},
                        lightly_active: activities.last_week.map {|r| r.lightly_active_minutes},
                        fairly_active: activities.last_week.map {|r| r.fairly_active_minutes},
                        very_active: activities.last_week.map {|r| r.very_active_minutes},
                        steps: activities.last_week.map {|r| r.steps},
                        days: activities.last_week.map{|r| r.date.strftime("%B %d")}
                        },
              sleep: {sleep_efficiency: activities.last_week.map {|r| r.sleep_efficiency},
                      number_of_awakenings: activities.last_week.map {|r| r.number_of_awakenings},
                      minutes: activities.last_week.map {|r| r.minutes_asleep}
                     }
              }
    end

    def activity_log_last_2_weeks
      #Package up the data for the activity log page
      return  {exercise: {sedentary: activities.last_2_weeks.map {|r| r.sedentary_minutes},
                          lightly_active: activities.last_2_weeks.map {|r| r.lightly_active_minutes},
                          fairly_active: activities.last_2_weeks.map {|r| r.fairly_active_minutes},
                          very_active: activities.last_2_weeks.map {|r| r.very_active_minutes},
                          steps: activities.last_2_weeks.map {|r| r.steps},
                          days: activities.last_2_weeks.map{|r| r.date.strftime("%B %d")}
      },
               sleep: {sleep_efficiency: activities.last_2_weeks.map {|r| r.sleep_efficiency},
                       number_of_awakenings: activities.last_2_weeks.map {|r| r.number_of_awakenings},
                       minutes: activities.last_2_weeks.map {|r| r.minutes_asleep}
               }
      }
    end

    def activity_log_last_month
      #Package up the data for the activity log page
      return  {exercise: {sedentary: activities.last_month.map {|r| r.sedentary_minutes},
                          lightly_active: activities.last_month.map {|r| r.lightly_active_minutes},
                          fairly_active: activities.last_month.map {|r| r.fairly_active_minutes},
                          very_active: activities.last_month.map {|r| r.very_active_minutes},
                          steps: activities.last_month.map {|r| r.steps},
                          days: activities.last_month.map{|r| r.date.strftime("%B %d")}
      },
               sleep: {sleep_efficiency: activities.last_month.map {|r| r.sleep_efficiency},
                       number_of_awakenings: activities.last_month.map {|r| r.number_of_awakenings},
                       minutes: activities.last_month.map {|r| r.minutes_asleep}
               }
      }
    end

    def scanForAlerts
      #Check all recent readings with threshold values and create Alerts
      #for each blood oxygen reading, compare with threshold
      blood_oxygen_readings.each do |r|
        if !alerts.exists?(reading_id: r.id)
          if r.bo_perc < threshold_values.bo_perc
            #create a new alert for this patient
            Alert.create(patient_id: id, urgent: true, reading_id: r.id, metric_name: "blood oxygen", text: "Blood Oxygen is under threshold")
          end
        end
      end

      heartRateThreshValues = eval(threshold_values.heart_rate)
      heart_rate_readings.each do |r|
        if !alerts.exists?(reading_id: r.id)
          if r.heart_rate >= heartRateThreshValues[:high]
            #create a new alert for this patient
            Alert.create(patient_id: id, urgent: true, reading_id: r.id, metric_name: "heart rate", text: "Heart Rate above threshold")
          end
          if r.heart_rate <= heartRateThreshValues[:low]
            #create a new alert for this patient
            Alert.create(patient_id: id, urgent: true, reading_id: r.id, metric_name: "heart rate", text: "Heart Rate below threshold")
          end
        end
      end

      thresholdSystolic = eval(threshold_values.systolic_bp)
      thresholdDiastolic = eval(threshold_values.diastolic_bp)

      blood_pressure_readings.each do |r|
        if !alerts.exists?(reading_id: r.id)
          if r.systolic_bp >= thresholdSystolic[:high]
            #create a new alert for this patient
            Alert.create(patient_id: id, urgent: true, reading_id: r.id, metric_name: "blood pressure", text: "Blood Pressure (Systolic) is HIGH")
          end
          if r.systolic_bp <= thresholdSystolic[:low]
            #create a new alert for this patient
            Alert.create(patient_id: id, urgent: true, reading_id: r.id, metric_name: "blood pressure", text: "Blood Pressure (Systolic) is LOW")
          end
          if r.diastolic_bp >= thresholdDiastolic[:high]
            #create a new alert for this patient
            Alert.create(patient_id: id, urgent: true, reading_id: r.id, metric_name: "blood pressure", text: "Blood Pressure (Diastolic) is HIGH")
          end
          if r.diastolic_bp <= thresholdDiastolic[:low]
            #create a new alert for this patient
            Alert.create(patient_id: id, urgent: true, reading_id: r.id, metric_name: "blood pressure", text: "Blood Pressure (Diastolic) is LOW")
          end
        end
      end

      emas.each do |r|
        if !alerts.exists?(reading_id: r.id)
          if r.sodium_level == "High"
            #create a new alert for this patient
            Alert.create(patient_id: id, urgent: true, reading_id: r.id, metric_name: "sodium", text: "Sodium Level is high")
          end
        end
      end

      weight_readings.each do |r|
        if !alerts.exists?(reading_id: r.id)
          relevant_weight_readings = weight_readings.where(reading_time: (r.reading_time - eval(threshold_values.weight)[:time].days) .. r.reading_time)
          if((relevant_weight_readings.maximum(:weight) - relevant_weight_readings.minimum(:weight)>=eval(threshold_values.weight)[:weight]) && !alerts.exists?(reading_id: relevant_weight_readings.order('weight desc').first.id))
            #create a new alert for this patient
            Alert.create(patient_id: id, urgent: true, reading_id: relevant_weight_readings.where(weight: relevant_weight_readings.maximum(:weight)).first().id, metric_name: "weight", text: "Change in weight has exceeded the threshold")
          end
        end
      end

      return alerts
    end

    def sodiumStringToInt(str)
      case str.downcase
      when "low"
        return 1
      when "medium"
        return 2
      when "high"
        return 3
      else
        return nil
      end
    end

    #more or less copied from Arduino library
  def map(x, in_min, in_max, out_min, out_max)  
      (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
  end

  def avg(val1, val2)
    (val1 + val2) / 2
  end

  def change(val1, val2)
    (val1 - val2)/val2
  end

  def max(val1, val2)
    if val1.abs > val2.abs
      val1
    else
      val2
    end
  end
  
end
