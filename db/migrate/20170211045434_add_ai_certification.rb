class AddAiCertification < ActiveRecord::Migration[5.0]
  def change
    add_column :animals, :ai_certification, :string
  end
end
