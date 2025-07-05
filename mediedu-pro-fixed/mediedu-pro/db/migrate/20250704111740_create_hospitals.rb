class CreateHospitals < ActiveRecord::Migration[8.0]
  def change
    create_table :hospitals do |t|
      t.string :name
      t.string :domain
      t.text :settings
      t.boolean :active

      t.timestamps
    end
  end
end
