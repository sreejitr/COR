class Ema < ActiveRecord::Base
	attr_accessible :patient_id, :temperature, :sodium_level, :quality_of_sleep, :reading_time

  if Rails.env.production?
    self.table_name = "ema"
    alias_attribute :sodium_level, :Sodium
    alias_attribute :reading_time, :Reading_time
  end

  scope :latest, -> {limit(1).order('reading_time desc').first}
  
  scope :last_week, -> {where(reading_time: 1.week.ago .. Time.now)}
  scope :last_2_weeks, -> {where(reading_time: 2.week.ago .. Time.now)}
  scope :last_month, -> {where(reading_time: 1.month.ago .. Time.now)}
  scope :last_three_months, -> {where(reading_time: 3.months.ago .. Time.now)}
  scope :last_six_months, -> {where(reading_time: 6.months.ago .. Time.now)}
  scope :last_year, -> {where(reading_time: 1.year.ago .. Time.now)}
end
