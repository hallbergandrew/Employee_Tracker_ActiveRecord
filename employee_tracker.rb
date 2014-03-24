require 'pry'
require 'active_record'
require './lib/employee'
require './lib/division'
require './lib/project'
require './lib/contribution.rb'

ActiveRecord::Base.establish_connection(YAML::load(File.open('./db/config.yml'))["development"])

def welcome
  system "clear"
  puts "Welcome to the Employee Tracker"
  menu
end

def menu
  choice = nil
  until choice == 'E'
    puts "Press 'a' to add an employee, 'l' to list your employees"
    puts "Press 'ad' to add a new division, and 'ld' to list divisions"
    puts "Press 'u' to see a list of all employees in a division"
    puts "Press 'ap' to add a new project, and 'lp' to list projects"
    puts "Press 'ep' to see a list of all employees on a project"
    puts "Press 'apd' to see all projects in a division"
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
    when 'AP'
      add_project
    when 'LP'
      list_projects
    when 'EP'
      all_in_projects
    when 'APD'
      all_projects_in_division
    when 'E'
      puts "Goodbye"
    else
      puts "Sorry, invalid option"
    end
  end
end

def add
  system "clear"
  puts "What is your employee name?"
  employee_name = gets.chomp
  puts "What division is this employee in?"
  d_name = gets.chomp
  if !Division.exists?({:name => d_name})  #If division already exists, don't add
    division = Division.new({:name => d_name})
    division.save
  else
    division = Division.where({:name => d_name}).first
  end

  puts "What project is this employee working on?"
  p_name = gets.chomp
  if !Project.exists?({:name => p_name})  #If project already exists, don't add
    new_project = Project.new({:name => p_name})
    new_project.save
  else
    new_project = Project.where({:name => p_name}).first
  end

  puts "What have you contributed to the project?"
  c_name = gets.chomp


  employee = Employee.new({:name => employee_name, :division_id => division.id})
  employee.save

  new_contribution = Contribution.new({:name => c_name, :project_id => new_project.id, :employee_id => employee.id})
  new_contribution.save

  # employee.update(:projects => [new_project], :contributions => [new_contribution])
  puts "'#{employee_name}' has been added to #{employee.division_id}: #{division.name} and to #{new_project.name}"
  puts "These employees have contributed to #{new_project.name}:"
  all_contributions = Contribution.where({:project_id => new_project.id})

  all_contributions.each do |contribution|
    puts contribution.employee.name
  end

end

def list
  system "clear"
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
  system "clear"
  puts "Here are the divisions"
  divisions = Division.all
  divisions.each { |division| puts division.name }
end

def all_in_division
  list_division
  puts "Please select the division by name, to see it's employees"
  d_name = gets.chomp
  selected_d = Division.where({:name => d_name}).first
  system "clear"
  puts "Here are the employees in #{selected_d.name}:"
  Employee.where({:division_id => selected_d.id}).to_a.each do |employee|
    puts employee.name
  end
end

def add_project
  puts "Enter the project name"
  p_name = gets.chomp
  new_project = Project.new({:name => p_name})
  new_project.save
  puts "#{new_project.name} Added"
end

def list_projects
  system "clear"
  puts "Here are your projects"
  Project.all.each { |project| puts project.name}
end

def all_in_projects
  list_projects
  puts "Please select the project by name, to see it's employees"
  p_name = gets.chomp
  selected_p = Project.where({:name => p_name}).first
  system "clear"
  puts "Here are the employees contributing to #{selected_p.name}:"
  selected_p.employees.each do |emp|
    puts emp.name
  end
end

def all_projects_in_division
  list_division
  puts "Please select a division to list all projects for:"
  choice = gets.chomp
  system "clear"
  puts "Here are the projects in Division #{choice}"
  Division.where({:name => choice}).first.employees.each { |employee| puts employee.projects.first.name }
end

welcome
