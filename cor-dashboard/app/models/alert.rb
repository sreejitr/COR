class Alert < ActiveRecord::Base
	attr_accessible :patient_id, :resolved_physician, :resolved_patient, :urgent, :reading_id, :created_date, :text, :metric_name
	belongs_to :patient
	after_initialize :default_values
  
	#These don't work for some reason :(
	def unresolved_and_not_urgent
		exists?({resolved_physician: false, urgent: false})
	end

	def unresolved_and_urgent
		exists?({resolved_physician: false, urgent: true})
	end

	def default_values
    self.resolved_physician ||= false
    self.resolved_patient ||= false    
  end
end
