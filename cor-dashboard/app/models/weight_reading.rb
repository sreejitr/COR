class WeightReading < ActiveRecord::Base

	attr_accessible  :patient_id, :weight, :hydration, :reading_time, :created_date, :weight_monitor_id
	belongs_to :patient

  if Rails.env.production?
    self.table_name = "weight_table"
  end

  scope :latest, -> {limit(1).order('reading_time desc').first}
  scope :last_n_days, ->(num) {where(reading_time: num.days.ago .. Time.now)}
	scope :last_n_weeks, ->(num) {where(reading_time: num.weeks.ago .. Time.now)}
  scope :last_n_months, ->(num) {where(reading_time: num.months.ago .. Time.now)}

  scope :last_week, -> {where(reading_time: 1.week.ago .. Time.now)}
  scope :last_2_weeks, -> {where(reading_time: 2.week.ago .. Time.now)}
  scope :last_month, -> {where(reading_time: 1.month.ago .. Time.now)}
  scope :last_three_months, -> {where(reading_time: 3.months.ago .. Time.now)}
  scope :last_six_months, -> {where(reading_time: 6.months.ago .. Time.now)}
  scope :last_year, -> {where(reading_time: 1.year.ago .. Time.now)}

end
