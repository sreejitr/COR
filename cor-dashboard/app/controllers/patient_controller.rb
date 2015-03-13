class PatientController < ApplicationController

  respond_to :html, :js
  
  def metrics
    #Fetch summary data by patient_id  
    #@patient = Patient.find(params[:id]) 
    @patient = Patient.take
    #Have to get this data here too, since we start with health summary
    @values = @patient.health_summary
  end

  def health_summary
    patient = Patient.take
    @values = patient.health_summary
  end


  def blood_oxygen
    patient = Patient.take  
    bundle = patient.blood_oxygen
    @threshold = bundle[:threshold]
    @values = bundle[:values]
  end

  def heart_rate   
    patient = Patient.take        
    bundle = patient.heart_rate
    @threshold = bundle[:threshold]
    @values = bundle[:values]
    @variability = bundle[:variability]
  end

  def weight
    patient = Patient.take      
    bundle = patient.weight
    @threshold = bundle[:threshold]
    @values = bundle[:values]
  end

  def sodium
    patient = Patient.take 
    bundle = patient.sodium
    @threshold = bundle[:threshold]
    @values = bundle[:values]
  end

  def blood_pressure
    patient = Patient.take         
    bundle = patient.blood_pressure
    @threshold = bundle[:threshold]
    @values = bundle[:values]
  end

  def medication    
  end

  def cough
  end

  def alerts
    #Fetch alert data by patient_id
    @patient = Patient.take
    @alerts = @patient.scanForAlerts
    #redirect to alerts
  end

  def patient_plan
    #Fetch patient_plan data by patient_id    
    #redirect to patient_plan
  end

  def activity_log
    #Fetch activity_log data by patient_id     
    #redirect to activity_log
    @patient = Patient.take
    @exercise_log = @patient.activity_log[:exercise]
  end

  def exercise_log
    @patient = Patient.take
    @exercise_log = @patient.activity_log[:exercise]
  end

  def settings
    #Fetch settings data by patient_id    
    #redirect to settings
    @patient = Patient.take
  end
end
