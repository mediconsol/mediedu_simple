class HomeController < ApplicationController
  def index
    @recent_quizzes = Quiz.published.limit(3)
    @total_quizzes = Quiz.published.count
    @total_documents = Document.completed.count
    
    # 임시 데이터 - 나중에 실제 병원/사용자 시스템으로 교체
    @current_hospital = Hospital.first || create_demo_hospital
    @demo_stats = {
      total_attempts: QuizAttempt.count,
      average_score: QuizAttempt.average(:score)&.round(1) || 0,
      active_users: 12 # 하드코딩된 임시 값
    }
  end
  
  private
  
  def create_demo_hospital
    Hospital.create!(
      name: "데모 병원",
      domain: "demo-hospital.mediedu.pro",
      active: true
    )
  end
end
