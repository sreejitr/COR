class Physician < ActiveRecord::Base
    attr_accessible :name
    has_many :patients

    if Rails.env.production?
      self.table_name = "physician"
    end
end
