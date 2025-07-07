# MediEdu Simple - 배포 가이드

## 배포 옵션

### 1. Render.com 배포 (추천)

1. [Render.com](https://render.com) 계정 생성
2. "New Web Service" 선택
3. GitHub 리포지토리 연결: `mediconsol/mediedu_simple`
4. 설정:
   - **Environment**: `Ruby`
   - **Build Command**: `bundle install && rails assets:precompile && rails db:create && rails db:migrate && rails db:seed`
   - **Start Command**: `rails server -p $PORT -e production`
5. 환경 변수 추가:
   - `RAILS_ENV=production`
   - `SECRET_KEY_BASE` (자동 생성)
   - `RAILS_SERVE_STATIC_FILES=true`
   - `RAILS_LOG_TO_STDOUT=true`

### 2. Railway 배포

1. [Railway.app](https://railway.app) 계정 생성
2. GitHub 리포지토리 연결
3. 자동 배포 설정
4. 환경 변수는 Render와 동일

### 3. Fly.io 배포

프로젝트에 이미 `fly.toml` 설정이 있습니다:

```bash
fly deploy
```

## 로컬 프로덕션 테스트

```bash
# 프로덕션 환경 설정
export RAILS_ENV=production
export SECRET_KEY_BASE=$(rails secret)
export RAILS_SERVE_STATIC_FILES=true

# 데이터베이스 설정
rails db:create db:migrate db:seed

# 애셋 프리컴파일
rails assets:precompile

# 서버 실행
rails server -e production
```

## 주요 설정

- ✅ SSL 비활성화 (무료 티어용)
- ✅ 정적 파일 서빙 활성화
- ✅ 호스트 제한 해제
- ✅ SQLite 데이터베이스 사용
- ✅ 로그 STDOUT 출력

## 배포 후 확인사항

1. 홈페이지 로딩 확인
2. 퀴즈 목록 페이지 확인
3. 문서 업로드 기능 확인
4. 데이터베이스 연결 확인

## 트러블슈팅

### 일반적인 문제들

1. **SECRET_KEY_BASE 오류**
   ```bash
   rails secret
   ```

2. **애셋 로딩 문제**
   - `RAILS_SERVE_STATIC_FILES=true` 환경변수 확인

3. **데이터베이스 오류**
   - 마이그레이션 실행: `rails db:migrate`

4. **메모리 부족**
   - 무료 티어 제한으로 인한 문제
   - 더 높은 플랜으로 업그레이드 고려
EOF < /dev/null