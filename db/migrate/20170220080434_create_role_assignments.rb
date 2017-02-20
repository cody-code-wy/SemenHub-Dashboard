class CreateRoleAssignments < ActiveRecord::Migration[5.0]
  def change
    create_table :role_assignments do |t|
      t.references :user
      t.references :role

      t.timestamps
    end
  end
end
