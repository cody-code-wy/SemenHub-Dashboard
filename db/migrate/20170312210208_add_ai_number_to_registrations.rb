class AddAiNumberToRegistrations < ActiveRecord::Migration[5.0]
  def change
    add_column :registrations, :ai_certification, :string
  end
end
