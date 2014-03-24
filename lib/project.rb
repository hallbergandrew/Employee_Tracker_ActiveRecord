class Project < ActiveRecord::Base
  # has_and_belongs_to_many :employees
  has_many :contributions
  has_many :employees, through: :contributions
end
