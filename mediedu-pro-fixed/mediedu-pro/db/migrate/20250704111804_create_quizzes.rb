class CreateQuizzes < ActiveRecord::Migration[8.0]
  def change
    create_table :quizzes do |t|
      t.string :title
      t.text :description
      t.text :questions_data
      t.integer :difficulty
      t.integer :status
      t.references :document, null: false, foreign_key: true

      t.timestamps
    end
  end
end
