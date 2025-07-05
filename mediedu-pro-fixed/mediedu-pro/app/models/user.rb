class User < ApplicationRecord
  belongs_to :hospital
  has_many :quiz_attempts, dependent: :destroy
  has_many :documents, foreign_key: 'uploaded_by_id', dependent: :destroy
  
  enum :role, { student: 0, instructor: 1, admin: 2, super_admin: 3 }
  enum :department, { 
    nursing: 0, medical: 1, administrative: 2, 
    laboratory: 3, pharmacy: 4, other: 5 
  }
  
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  
  scope :active, -> { where(active: true) }
  scope :by_department, ->(dept) { where(department: dept) }
  scope :by_role, ->(role) { where(role: role) }
  
  def total_points
    quiz_attempts.sum(:score)
  end
  
  def average_score
    quiz_attempts.average(:score) || 0
  end
end
