class QuizAttempt < ApplicationRecord
  belongs_to :user
  belongs_to :quiz
  
  validates :score, presence: true, numericality: { in: 0..100 }
  validates :time_spent, presence: true, numericality: { greater_than: 0 }
  
  scope :completed, -> { where.not(completed_at: nil) }
  scope :recent, -> { order(created_at: :desc) }
  
  def completed?
    completed_at.present?
  end
  
  def completion_rate
    return 0 unless quiz.questions.present?
    
    (score.to_f / 100) * 100
  end
end
