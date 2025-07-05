class CreateDocuments < ActiveRecord::Migration[8.0]
  def change
    create_table :documents do |t|
      t.string :title
      t.text :content
      t.integer :category
      t.integer :status
      t.references :hospital, null: false, foreign_key: true
      t.references :uploaded_by, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
