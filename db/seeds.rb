# MediEdu Pro 시드 데이터

puts "🏥 병원 데이터 생성 중..."

# 데모 병원 생성
hospital = Hospital.find_or_create_by!(domain: "demo-hospital.mediedu.pro") do |h|
  h.name = "서울대병원"
  h.active = true
end

puts "✅ 병원 생성됨: #{hospital.name}"

# 데모 사용자 생성
puts "👤 사용자 데이터 생성 중..."

users = [
  {
    name: "김간호사",
    email: "nurse.kim@demo-hospital.com",
    role: :student,
    department: :nursing,
    active: true
  },
  {
    name: "이의사",
    email: "doctor.lee@demo-hospital.com", 
    role: :instructor,
    department: :medical,
    active: true
  },
  {
    name: "박관리자",
    email: "admin.park@demo-hospital.com",
    role: :admin,
    department: :administrative,
    active: true
  }
]

users.each do |user_data|
  user = User.find_or_create_by!(email: user_data[:email]) do |u|
    u.name = user_data[:name]
    u.hospital = hospital
    u.role = user_data[:role]
    u.department = user_data[:department]
    u.active = user_data[:active]
  end
  puts "✅ 사용자 생성됨: #{user.name} (#{user.role})"
end

# 데모 문서 생성
puts "📄 문서 데이터 생성 중..."

admin_user = User.find_by(role: :admin)

documents = [
  {
    title: "감염 관리 매뉴얼",
    content: "병원 내 감염을 예방하고 관리하기 위한 종합적인 가이드라인입니다. 
              손 씻기는 감염 예방의 가장 기본적이고 중요한 방법입니다. 
              의료진은 환자 접촉 전후에 반드시 손을 씻어야 합니다.
              개인보호장비(PPE) 착용 시에는 정확한 순서를 따라야 합니다.
              격리 환자 관리 시에는 별도의 프로토콜을 적용해야 합니다.",
    category: :infection_control,
    status: :completed
  },
  {
    title: "환자 안전 프로토콜",
    content: "환자의 안전을 보장하기 위한 필수적인 절차와 체크리스트입니다.
              환자 확인은 최소 2가지 방법으로 해야 합니다.
              낙상 위험 환자는 별도 표시를 해야 합니다.
              약물 투여 전에는 5Rights를 확인해야 합니다.
              응급상황 시 신속한 대응 체계를 갖춰야 합니다.",
    category: :patient_safety,
    status: :completed
  },
  {
    title: "간호 술기 가이드",
    content: "기본적인 간호 술기부터 고급 술기까지의 상세한 절차를 설명합니다.
              활력징후 측정은 정확한 방법으로 해야 합니다.
              주사 투여 시에는 무균술을 준수해야 합니다.
              상처 드레싱은 감염 예방에 중점을 둬야 합니다.
              환자 이동 시에는 안전을 최우선으로 해야 합니다.",
    category: :nursing_procedures,
    status: :completed
  }
]

documents.each do |doc_data|
  document = Document.find_or_create_by!(title: doc_data[:title]) do |d|
    d.content = doc_data[:content]
    d.category = doc_data[:category]
    d.status = doc_data[:status]
    d.hospital = hospital
    d.uploaded_by = admin_user
  end
  puts "✅ 문서 생성됨: #{document.title}"
end

# 데모 퀴즈 생성
puts "🎯 퀴즈 데이터 생성 중..."

Document.all.each do |document|
  # 각 문서마다 퀴즈 생성
  quiz_data = case document.category
  when "infection_control"
    {
      title: "감염 관리 기본 지식 퀴즈",
      description: "병원 내 감염 예방과 관리에 대한 기본적인 지식을 테스트합니다.",
      difficulty: :beginner,
      questions: [
        {
          type: "multiple_choice",
          question: "손 씻기를 해야 하는 시점은 언제인가요?",
          options: ["환자 접촉 전", "환자 접촉 후", "환자 접촉 전후 모두", "필요시에만"],
          correct_answer: 2,
          explanation: "손 씻기는 환자 접촉 전후 모두 실시해야 합니다."
        },
        {
          type: "true_false",
          question: "개인보호장비(PPE) 착용 순서는 중요하지 않다.",
          options: ["참", "거짓"],
          correct_answer: 1,
          explanation: "PPE 착용 순서는 감염 예방을 위해 매우 중요합니다."
        },
        {
          type: "multiple_choice",
          question: "격리 환자 관리 시 가장 중요한 것은?",
          options: ["빠른 치료", "별도 프로토콜 적용", "비용 절감", "편의성"],
          correct_answer: 1,
          explanation: "격리 환자는 감염 확산 방지를 위해 별도 프로토콜을 적용해야 합니다."
        }
      ]
    }
  when "patient_safety"
    {
      title: "환자 안전 프로토콜 퀴즈",
      description: "환자 안전을 위한 필수 프로토콜과 절차에 대한 이해도를 평가합니다.",
      difficulty: :intermediate,
      questions: [
        {
          type: "multiple_choice",
          question: "환자 확인은 최소 몇 가지 방법으로 해야 하나요?",
          options: ["1가지", "2가지", "3가지", "4가지"],
          correct_answer: 1,
          explanation: "환자 확인은 최소 2가지 방법(이름, 생년월일 등)으로 해야 합니다."
        },
        {
          type: "multiple_choice", 
          question: "약물 투여 전 확인해야 할 5Rights에 포함되지 않는 것은?",
          options: ["올바른 환자", "올바른 약물", "올바른 용량", "올바른 보험"],
          correct_answer: 3,
          explanation: "5Rights는 환자, 약물, 용량, 시간, 경로를 말합니다."
        },
        {
          type: "true_false",
          question: "낙상 위험 환자에게는 별도 표시가 필요하다.",
          options: ["참", "거짓"],
          correct_answer: 0,
          explanation: "낙상 위험 환자는 식별을 위해 별도 표시를 해야 합니다."
        }
      ]
    }
  when "nursing_procedures"
    {
      title: "간호 술기 실무 퀴즈",
      description: "기본 간호 술기와 실무 적용에 대한 지식을 확인합니다.",
      difficulty: :advanced,
      questions: [
        {
          type: "multiple_choice",
          question: "무균술의 기본 원칙이 아닌 것은?",
          options: ["멸균된 물품 사용", "손 소독", "빠른 처치", "무균 영역 유지"],
          correct_answer: 2,
          explanation: "무균술은 속도보다는 정확성과 안전성이 중요합니다."
        },
        {
          type: "multiple_choice",
          question: "활력징후 측정 시 가장 우선적으로 확인해야 할 것은?",
          options: ["체온", "맥박", "호흡", "의식수준"],
          correct_answer: 3,
          explanation: "의식수준은 환자의 전반적인 상태를 가장 잘 반영합니다."
        },
        {
          type: "true_false",
          question: "상처 드레싱 시 감염 예방이 가장 중요하다.",
          options: ["참", "거짓"],
          correct_answer: 0,
          explanation: "상처 드레싱의 주요 목적 중 하나는 감염 예방입니다."
        }
      ]
    }
  end
  
  quiz = Quiz.find_or_create_by!(title: quiz_data[:title]) do |q|
    q.description = quiz_data[:description]
    q.difficulty = quiz_data[:difficulty]
    q.questions_data = quiz_data[:questions].to_json
    q.status = :published
    q.document = document
  end
  
  puts "✅ 퀴즈 생성됨: #{quiz.title} (#{quiz.difficulty})"
end

# 데모 퀴즈 시도 기록 생성
puts "📊 퀴즈 시도 데이터 생성 중..."

student_users = User.where(role: :student)
Quiz.published.each do |quiz|
  student_users.each do |user|
    # 각 학생마다 퀴즈 시도 기록 생성 (랜덤 점수)
    score = rand(60..100)
    time_spent = rand(300..1800) # 5분~30분
    
    QuizAttempt.find_or_create_by!(user: user, quiz: quiz) do |attempt|
      attempt.score = score
      attempt.time_spent = time_spent
      attempt.completed_at = rand(1.week.ago..Time.current)
    end
  end
end

puts "✅ 퀴즈 시도 기록 생성 완료"

puts "🎉 시드 데이터 생성이 완료되었습니다!"
puts "📊 통계:"
puts "   - 병원: #{Hospital.count}개"
puts "   - 사용자: #{User.count}명"
puts "   - 문서: #{Document.count}개"
puts "   - 퀴즈: #{Quiz.count}개"
puts "   - 퀴즈 시도: #{QuizAttempt.count}회"
