class Document < ApplicationRecord
  belongs_to :hospital
  belongs_to :uploaded_by, class_name: 'User'
  has_many :quizzes, dependent: :destroy
  
  enum :status, { pending: 0, processing: 1, completed: 2, failed: 3 }
  enum :category, { 
    infection_control: 0, patient_safety: 1, nursing_procedures: 2,
    medical_protocols: 3, administrative: 4, emergency: 5 
  }
  
  validates :title, presence: true
  validates :content, presence: true
  
  scope :by_category, ->(cat) { where(category: cat) }
  scope :completed, -> { where(status: :completed) }
end
