class RemoveAiCertificationFromAnimal < ActiveRecord::Migration[5.0]
  def change
    remove_column :animals, :ai_certification
  end
end
