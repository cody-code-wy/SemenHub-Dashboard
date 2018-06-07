class CreateImages < ActiveRecord::Migration[5.0]
  def change
    create_table :images do |t|
      t.string :url_format
      t.string :s3_object
      t.references :animal

      t.timestamps
    end
  end
end
