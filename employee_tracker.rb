require 'active_record'
require './lib/employee'

ActiveRecord::Base.establish_connection(YAML::load(File.open('./db/config.yml'))["development"])

def welcome
  puts "Welcome to the Employee Tracker"
  menu
end

def menu
  choice = nil
  until choice == 'E'
    puts "Press 'a' to add an employee, 'l' to list your employees"
    puts "Press 'e' to exit"
    choice = gets.chomp.upcase
    case choice
    when 'A'
      add
    when 'L'
      list
    when 'E'
      puts "Goodbye"
    else
      puts "Sorry, invalid option"
    end
  end
end

def add
  puts "What is your employee name?"
  employee_name = gets.chomp
  employee = Employee.new({:name => employee_name})
  employee.save
  puts "'#{employee_name}' has been added"
end

def list
  puts "Here are your employees"
  employees = Employee.all
  employees.each { |employee| puts employee.name }
end

welcome
