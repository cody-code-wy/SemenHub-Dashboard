class AddDnaNumber < ActiveRecord::Migration[5.0]
  def change
    add_column :animals, :dna_number, :string
  end
end
