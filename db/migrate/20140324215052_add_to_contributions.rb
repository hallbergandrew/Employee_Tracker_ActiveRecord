class AddToContributions < ActiveRecord::Migration
  def change
    add_column :contributions, :employee_id, :integer
    add_column :contributions, :project_id, :integer

  end
end
