class AddTimestampsToRegistrations < ActiveRecord::Migration[5.0]
  def up
    add_column :registrations, :created_at, :datetime, default: DateTime.now, null: false
    add_column :registrations, :updated_at, :datetime, default: DateTime.now, null: false
  end

  def down
    remove_column :registrations, :created_at
    remove_column :registrations, :updated_at
  end
end
