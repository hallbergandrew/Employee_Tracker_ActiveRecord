require 'active_record'
require './lib/employee'
require './lib/division'

ActiveRecord::Base.establish_connection(YAML::load(File.open('./db/config.yml'))["development"])

def welcome
  puts "Welcome to the Employee Tracker"
  menu
end

def menu
  choice = nil
  until choice == 'E'
    puts "Press 'a' to add an employee, 'l' to list your employees"
    puts "Press 'ad' to add a new division, and 'ld' to list divisions"
    puts "Press 'u' to see a list of all employees in a division"
    puts "Press 'e' to exit"
    choice = gets.chomp.upcase
    case choice
    when 'A'
      add
    when 'L'
      list
    when 'AD'
      add_division
    when 'LD'
      list_division
    when 'U'
      all_in_division
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
  puts "What division is this employee in?"
  d_name = gets.chomp
  division = Division.new({:name => d_name})
  division.save
  employee = Employee.new({:name => employee_name, :division_id => division.id})
  employee.save
  puts "'#{employee_name}' has been added to #{employee.division_id}: #{division.name}"
end

def list
  puts "Here are your employees"
  employees = Employee.all
  employees.each { |employee| puts employee.name }
end

def add_division
  puts "What is the name of the new division?"
  d_name = gets.chomp
  division = Division.new({:name => d_name})
  division.save
  puts " '#{d_name}' has been added"
end

def list_division
  puts "Here are the divisions"
  divisions = Division.all
  divisions.each { |division| puts division.name }
end

def all_in_division
  list_division
  puts "Please select the division by name, to see it's employees"
  d_name = gets.chomp
  selected_d = Division.where({:name => d_name}).first
  Employee.where({:division_id => selected_d.id}).to_a.each do |employee|
    puts employee.name
  end
end


welcome
