class AddToEmployeesProjects < ActiveRecord::Migration
  def change
    add_column :employees_projects, :contributions, :string
  end
end
