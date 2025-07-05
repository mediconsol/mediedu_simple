# MediEdu Pro - AI 기반 병원 교육 플랫폼

**MediEdu Pro**는 병원 맞춤형 AI 교육 플랫폼입니다. 병원이 보유한 SOP, 매뉴얼, 프로토콜을 AI가 분석하여 맞춤형 퀴즈를 생성하고, 의료진이 게임처럼 즐기며 학습할 수 있는 플랫폼입니다.

## 🚀 주요 기능

### 📄 문서 관리
- SOP, 매뉴얼, 프로토콜 업로드
- 카테고리별 문서 분류
- 문서 검색 및 필터링

### 🤖 AI 퀴즈 생성
- 문서 내용 자동 분석
- 난이도별 퀴즈 생성
- 객관식, 참/거짓 문제 지원

### 📊 상세한 결과 분석
- 문제별 정답/오답 분석
- 개인맞춤 학습 피드백
- 성취도 시각화

### 🎯 사용자 경험
- 반응형 웹 디자인
- 직관적인 사용자 인터페이스
- 실시간 진도 추적

## 🛠️ 기술 스택

- **Framework**: Ruby on Rails 8.0.2
- **Database**: SQLite (개발), PostgreSQL (프로덕션)
- **Frontend**: Tailwind CSS, JavaScript
- **Authentication**: 세션 기반 인증
- **Deployment**: Render (무료 호스팅)

## 📦 설치 및 실행

### 필수 요구사항
- Ruby 3.3.0
- Rails 8.0.2
- Node.js (Tailwind CSS용)

### 로컬 개발 환경 설정

```bash
# 저장소 클론
git clone https://github.com/your-username/mediedu-pro.git
cd mediedu-pro

# 의존성 설치
bundle install

# 데이터베이스 설정
rails db:create
rails db:migrate
rails db:seed

# 서버 실행
rails server -p 5555
```

브라우저에서 `http://localhost:5555`로 접속하세요.

## 🚀 배포

### Render.com 배포 (무료)

1. [Render.com](https://render.com)에 회원가입
2. GitHub 저장소 연결
3. `render.yaml` 파일이 자동으로 설정을 처리합니다
4. 환경변수 `RAILS_MASTER_KEY` 설정 필요

### 환경변수 설정

프로덕션 환경에서 다음 환경변수가 필요합니다:

```
RAILS_MASTER_KEY=<Rails credentials master key>
DATABASE_URL=<PostgreSQL connection string>
```

## 📱 사용법

### 1. 문서 업로드
1. "새 문서 업로드" 버튼 클릭
2. 문서 제목, 카테고리 선택
3. 문서 내용 입력 또는 파일 업로드
4. 공개 설정 선택 후 업로드

### 2. AI 퀴즈 생성
1. 문서 목록에서 "AI 퀴즈 생성" 버튼 클릭
2. 퀴즈 제목, 설명, 난이도 설정
3. AI가 자동으로 문제 생성
4. 생성 완료 후 즉시 사용 가능

### 3. 퀴즈 진행
1. "퀴즈 시작하기" 버튼 클릭
2. 문제별로 답안 선택
3. 마지막 문제 완료 후 결과 확인
4. 상세한 문제별 분석 리뷰

## 🎨 UI/UX 특징

- **모던 디자인**: Tailwind CSS 기반 반응형 디자인
- **애니메이션**: 부드러운 전환 효과
- **시각적 피드백**: 색상으로 구분된 정답/오답 표시
- **접근성**: 명확한 시각적 계층구조

## 📊 데이터베이스 스키마

### 주요 모델
- `Hospital`: 병원 정보
- `User`: 사용자 계정
- `Document`: 업로드된 문서
- `Quiz`: 생성된 퀴즈
- `QuizAttempt`: 퀴즈 시도 기록

## 🔧 개발 도구

### 코드 품질
```bash
# 린트 검사
bundle exec rubocop

# 보안 검사
bundle exec brakeman
```

### 테스트
```bash
# 전체 테스트 실행
rails test

# 특정 테스트 실행
rails test test/models/quiz_test.rb
```

## 🤝 기여하기

1. 이 저장소를 Fork하세요
2. 기능 브랜치를 생성하세요 (`git checkout -b feature/amazing-feature`)
3. 변경사항을 커밋하세요 (`git commit -m 'Add amazing feature'`)
4. 브랜치에 Push하세요 (`git push origin feature/amazing-feature`)
5. Pull Request를 생성하세요

## 📄 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다.

## 📞 지원

문제가 있거나 제안사항이 있으시면 이슈를 생성해주세요.

---

**MediEdu Pro** - 의료진 교육의 디지털 혁신 🏥✨
