class Hospital < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :documents, dependent: :destroy
  has_many :quizzes, through: :documents
  
  validates :name, presence: true
  validates :domain, presence: true, uniqueness: true
  
  before_save :downcase_domain
  
  scope :active, -> { where(active: true) }
  
  private
  
  def downcase_domain
    self.domain = domain.downcase if domain.present?
  end
end
