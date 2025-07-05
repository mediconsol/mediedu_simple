class QuizzesController < ApplicationController
  before_action :set_quiz, only: [:show, :attempt, :next_question, :result]
  before_action :set_document, only: [:new, :create]
  
  def index
    @quizzes = Quiz.published.includes(:document)
    @quizzes = @quizzes.joins(:document).where(documents: { category: params[:category] }) if params[:category].present?
    @quizzes = @quizzes.where(difficulty: params[:difficulty]) if params[:difficulty].present?
  end

  def show
    @questions = @quiz.questions
    @current_question = params[:question_number]&.to_i || 1
    @total_questions = @questions.length
    
    if @current_question > @total_questions
      redirect_to quizzes_path, alert: "퀴즈가 완료되었습니다."
      return
    end
    
    @question = @questions[@current_question - 1] if @questions.present?
  end
  
  def next_question
    # 답안 저장 로직
    answer = params[:answer]
    question_number = params[:question_number].to_i
    
    if answer.present?
      # 세션에 답안 저장
      session[:quiz_answers] ||= {}
      session[:quiz_answers][@quiz.id.to_s] ||= {}
      session[:quiz_answers][@quiz.id.to_s][question_number.to_s] = answer
    end
    
    # 다음 문제로 이동 또는 완료 처리
    next_question_number = question_number + 1
    total_questions = @quiz.questions.length
    
    if next_question_number <= total_questions
      redirect_to quiz_path(@quiz, question_number: next_question_number)
    else
      # 퀴즈 완료 - attempt 액션으로 리다이렉트
      redirect_to quiz_path(@quiz, action: :attempt, answers: session[:quiz_answers][@quiz.id.to_s])
    end
  end
  
  def attempt
    # 답안 데이터 수집 (폼 데이터 우선, 세션 데이터 백업)
    answers = params[:answers] || {}
    
    # 세션에서 저장된 답안도 병합 (누락된 답안 보완)
    if session[:quiz_answers] && session[:quiz_answers][@quiz.id.to_s]
      session_answers = session[:quiz_answers][@quiz.id.to_s]
      session_answers.each do |question_num, answer|
        answers[question_num] ||= answer
      end
    end
    
    # 퀴즈 시도 처리 로직
    score = calculate_score(answers)
    time_spent = params[:time_spent]&.to_i || 0
    
    # 임시 사용자 생성 (나중에 실제 인증 시스템으로 교체)
    user = get_or_create_demo_user
    
    @quiz_attempt = QuizAttempt.create!(
      user: user,
      quiz: @quiz,
      score: score,
      time_spent: time_spent,
      completed_at: Time.current
    )
    
    # 세션 정리
    session[:quiz_answers]&.delete(@quiz.id.to_s)
    
    redirect_to result_quiz_path(@quiz, quiz_attempt_id: @quiz_attempt.id)
  end
  
  def result
    @quiz_attempt = QuizAttempt.find(params[:quiz_attempt_id])
    @quiz = @quiz_attempt.quiz
    
    # 사용자가 입력한 답안 정보 (세션에서 가져오기 시도)
    @user_answers = session[:quiz_answers]&.dig(@quiz.id.to_s) || {}
    
    # 문제별 결과 분석
    @question_results = analyze_question_results(@quiz, @user_answers)
    @correct_count = @question_results.count { |result| result[:correct] }
    @total_questions = @quiz.questions.length
  end
  
  def new
    @quiz = @document.quizzes.build
  end
  
  def create
    @quiz = @document.quizzes.build(quiz_params)
    
    # AI가 문서 내용을 분석해서 퀴즈를 생성하는 로직 (임시로 샘플 데이터 생성)
    sample_questions = generate_sample_questions(@document)
    @quiz.questions = sample_questions
    @quiz.status = :published
    
    if @quiz.save
      redirect_to quiz_path(@quiz), notice: "AI 퀴즈가 성공적으로 생성되었습니다!"
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  private
  
  def set_quiz
    @quiz = Quiz.find(params[:id])
  end
  
  def set_document
    @document = Document.find(params[:document_id])
  end
  
  def quiz_params
    params.require(:quiz).permit(:title, :description, :difficulty)
  end
  
  def generate_sample_questions(document)
    # 실제로는 OpenAI API나 다른 AI 서비스를 사용해서 문서 내용을 분석하고 퀴즈를 생성
    # 현재는 샘플 데이터로 대체
    
    base_questions = [
      {
        "question" => "#{document.title}에서 가장 중요한 핵심 내용은 무엇입니까?",
        "type" => "multiple_choice",
        "options" => [
          "환자 안전 확보",
          "업무 효율성 향상", 
          "비용 절감",
          "규정 준수"
        ],
        "correct_answer" => 0
      },
      {
        "question" => "이 문서에서 제시하는 절차를 올바른 순서대로 진행해야 합니다.",
        "type" => "multiple_choice",
        "options" => [
          "맞습니다",
          "틀립니다"
        ],
        "correct_answer" => 0
      },
      {
        "question" => "문서에 명시된 주의사항을 무시해도 됩니까?",
        "type" => "multiple_choice", 
        "options" => [
          "절대 안됩니다",
          "상황에 따라 가능합니다",
          "의사 판단에 맡깁니다",
          "환자가 원하면 가능합니다"
        ],
        "correct_answer" => 0
      }
    ]
    
    # 문서 내용 길이에 따라 질문 수 조정
    question_count = [(document.content.length / 200), 10].min.to_i
    question_count = [question_count, 3].max
    
    # 기본 질문을 반복하고 약간씩 변형
    questions = []
    question_count.times do |i|
      base_question = base_questions[i % base_questions.length].dup
      if i >= base_questions.length
        base_question["question"] = "#{document.category.humanize} 관련 #{i+1}번째 문제: #{base_question['question']}"
      end
      questions << base_question
    end
    
    questions
  end
  
  def analyze_question_results(quiz, user_answers)
    results = []
    
    quiz.questions.each_with_index do |question, index|
      question_number = (index + 1).to_s
      user_answer_index = user_answers[question_number]&.to_i
      correct_answer_index = question['correct_answer']&.to_i
      
      is_correct = user_answer_index == correct_answer_index
      
      result = {
        question_number: index + 1,
        question: question['question'],
        options: question['options'],
        user_answer_index: user_answer_index,
        user_answer_text: user_answer_index ? question['options'][user_answer_index] : '답변하지 않음',
        correct_answer_index: correct_answer_index,
        correct_answer_text: question['options'][correct_answer_index],
        correct: is_correct,
        explanation: generate_explanation(question, is_correct)
      }
      
      results << result
    end
    
    results
  end
  
  def generate_explanation(question, is_correct)
    # 실제로는 AI가 생성하거나 미리 작성된 해설을 사용
    # 현재는 간단한 해설 생성
    if is_correct
      "정답입니다! #{question['options'][question['correct_answer']]}이(가) 올바른 답입니다."
    else
      "아쉽게도 틀렸습니다. 정답은 '#{question['options'][question['correct_answer']]}' 입니다. 해당 내용을 다시 한번 복습해보세요."
    end
  end
  
  def calculate_score(answers)
    return 0 unless answers.present? && @quiz.questions.present?
    
    correct_answers = 0
    total_questions = @quiz.questions.length
    
    @quiz.questions.each_with_index do |question, index|
      # 인덱스는 0부터 시작하지만, 질문 번호는 1부터 시작
      question_number = (index + 1).to_s
      user_answer = answers[question_number]&.to_i
      correct_answer = question['correct_answer']&.to_i
      
      correct_answers += 1 if user_answer == correct_answer
    end
    
    (correct_answers.to_f / total_questions * 100).round
  end
  
  def get_or_create_demo_user
    hospital = Hospital.first || Hospital.create!(
      name: "데모 병원",
      domain: "demo-hospital.mediedu.pro",
      active: true
    )
    
    User.find_or_create_by(email: "demo@example.com") do |user|
      user.name = "데모 사용자"
      user.hospital = hospital
      user.role = :student
      user.department = :nursing
      user.active = true
    end
  end
end
