class Zone < ActiveRecord::Base
  belongs_to :school
  has_many :student_attendances
end
