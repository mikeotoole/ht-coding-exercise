class CreateSf311Cases < ActiveRecord::Migration
  def change
    create_table :sf311_cases do |t|
      t.integer :category_id, null: false
      t.integer :source_id, null: false
      t.string :request_details
      t.string :address, null: false
      t.string :request_type, null: false
      t.datetime :last_updated_at, null: false
      t.string :neighborhood, null: false
      t.integer :case_id, null: false
      t.datetime :closed_at
      t.integer :supervisor_district, null: false
      t.string :responsible_agency, null: false
      t.datetime :opened_at, null: false
      t.decimal :latitude, precision: 16, scale: 13, null: false
      t.decimal :longitude, precision: 16, scale: 13, null: false

      t.timestamps null: false

      t.index :category_id
      t.index :source_id
      t.index :latitude
      t.index :longitude
      t.index :case_id, unique: true
      t.index :opened_at
      t.index :closed_at
    end
  end
end
