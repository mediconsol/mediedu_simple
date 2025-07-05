class Quiz < ApplicationRecord
  belongs_to :document
  has_many :quiz_attempts, dependent: :destroy
  
  enum :difficulty, { beginner: 0, intermediate: 1, advanced: 2 }
  enum :status, { draft: 0, published: 1, archived: 2 }
  
  validates :title, presence: true
  validates :questions_data, presence: true
  
  scope :published, -> { where(status: :published) }
  scope :by_difficulty, ->(level) { where(difficulty: level) }
  
  def questions
    JSON.parse(questions_data) if questions_data.present?
  rescue JSON::ParserError
    []
  end
  
  def questions=(data)
    self.questions_data = data.to_json
  end
  
  def question_count
    questions.length
  end
end
