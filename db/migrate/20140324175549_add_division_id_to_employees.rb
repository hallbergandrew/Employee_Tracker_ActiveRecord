class AddDivisionIdToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :division_id, :int
  end
end
