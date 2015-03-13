class BloodPressureReading < ActiveRecord::Base
	attr_accessible :patient_id, :bp_sensor_id, :systolic_bp, :diastolic_bp, :reading_time, :created_date
	belongs_to :patient

  if Rails.env.production?
    self.table_name = "blood_pressure_raw"
    alias_attribute :systolic_bp, :systolic
    alias_attribute :diastolic_bp, :diastolic
  end

	def current
		BloodPressureReading.take
  end

  scope :latest, -> {limit(1).order('reading_time desc').first}
  
  scope :last_week, -> {where(reading_time: 1.week.ago .. Time.now)}
  scope :last_2_weeks, -> {where(reading_time: 2.week.ago .. Time.now)}
  scope :last_month, -> {where(reading_time: 1.month.ago .. Time.now)}
  scope :last_three_months, -> {where(reading_time: 3.months.ago .. Time.now)}
  scope :last_six_months, -> {where(reading_time: 6.months.ago .. Time.now)}
  scope :last_year, -> {where(reading_time: 1.year.ago .. Time.now)}

end
