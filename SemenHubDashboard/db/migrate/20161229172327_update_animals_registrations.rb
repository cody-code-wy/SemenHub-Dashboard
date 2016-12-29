class UpdateAnimalsRegistrations < ActiveRecord::Migration[5.0]
  def change
    change_table :animals do |t|
      t.remove :registration_id
    end

    change_table :registrations do |t|
      t.references :animal, foriegn_key: true
    end
  end
end
