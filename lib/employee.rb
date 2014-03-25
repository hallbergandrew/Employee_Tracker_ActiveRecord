class Employee < ActiveRecord::Base
  belongs_to :division

  has_many :contributions
  # has_and_belongs_to_many :projects
  has_many :projects, through: :contributions
end
