class CreateContributions < ActiveRecord::Migration
  def change
    create_table :contributions do |t|
      t.belongs_to :project
      t.belongs_to :employee
      t.column :name, :string


      t.timestamps
    end
  end
end
